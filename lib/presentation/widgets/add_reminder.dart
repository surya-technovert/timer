import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/services/notification_service.dart';
import 'package:Reminder/presentation/widgets/cutom_text_field.dart';
import 'package:Reminder/presentation/utils/extensions/context_extensions.dart';
import 'package:Reminder/presentation/providers/value_providers/data_provider.dart';
import 'package:Reminder/presentation/providers/value_providers/selected_time_provider.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/error_helpers/error_helper.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/button_helpers/action_button.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/notify_helpers/snack_bar_notify.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/input_field_helpers/limit_range_input.dart';

class AddReminder extends ConsumerStatefulWidget {
  const AddReminder({super.key});

  @override
  ConsumerState<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends ConsumerState<AddReminder> {
  final _key = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sheduleTimeController = TextEditingController();
  final TextEditingController reoccuranceMinController =
      TextEditingController();
  final TextEditingController reoccuranceHourController =
      TextEditingController();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: context.screenWidth,
                height: context.screenHeight,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 238, 238, 1)
                        .withOpacity(0.5)),
                child: AlertDialog(
                  scrollable: true,
                  title: Text(
                    'New Reminder',
                    style: TextStyle(
                        fontFamily: 'Lugrasimo', color: context.primartyColor),
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    width: context.screenWidth,
                    constraints:
                        BoxConstraints(maxHeight: context.screenHeight * 0.6),
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomInputField(
                            fieldController: titleController,
                            hintText: 'Title',
                            errorText: 'Please Enter Some Text',
                            icon: CupertinoIcons.square_list,
                          ),
                          const SizedBox(height: 15),
                          CustomInputField(
                            fieldController: descriptionController,
                            hintText: 'Description',
                            errorText: 'Please Enter Some Text',
                            icon: CupertinoIcons.bubble_left_bubble_right,
                          ),
                          const SizedBox(height: 15),
                          CustomInputField(
                              fieldController: sheduleTimeController,
                              hintText: 'Select the Shedule Time',
                              errorText: 'Please Select Time',
                              icon: Icons.timer_sharp,
                              readOnly: true,
                              onTap: () async {
                                sheduleTimeController.text =
                                    (ref.watch(selectedTimeProvider))
                                        .format(context)
                                        .toString();
                                ref
                                    .read(selectedTimeProvider.notifier)
                                    .updateTime(await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    ).then((value) => (value == null)
                                        ? value = TimeOfDay.now()
                                        : value));
                              }),
                          const SizedBox(height: 15),
                          CustomInputField(
                            fieldController: reoccuranceHourController,
                            hintText: 'Enter Reoccurance Hour',
                            errorText: 'Please enter between 0 to 24',
                            icon: CupertinoIcons.timer,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            maxLines: 1,
                            inputParameters: [
                              LengthLimitingTextInputFormatter(2,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced),
                              LimitRangeInput(0, 23),
                            ],
                          ),
                          const SizedBox(height: 15),
                          CustomInputField(
                            fieldController: reoccuranceMinController,
                            hintText: 'Enter Reoccurance Minute',
                            errorText: 'Please enter between 0 to 60',
                            icon: CupertinoIcons.timer,
                            maxLines: 1,
                            inputParameters: [
                              LengthLimitingTextInputFormatter(2),
                              LimitRangeInput(0, 59),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ActionButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        }),
                    ActionButton(
                        buttonText: 'Add',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      context.displayLoading));
                          _addReminder().then((value) => (value)
                              ? Navigator.of(context)
                                  .popUntil((_) => count++ >= 2)
                              : null);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _addReminder() async {
    if (_key.currentState!.validate()) {
      final DateTime timeWithSec = DateTime.now();
      DateTime now = DateTime(timeWithSec.year, timeWithSec.month,
          timeWithSec.day, timeWithSec.hour, timeWithSec.minute);
      final String remTitle = titleController.text;
      final String remDesc = descriptionController.text;
      DateTime sheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          ref.read(selectedTimeProvider).hour,
          ref.read(selectedTimeProvider).minute);
      final int reoccuranceHour = int.parse(reoccuranceHourController.text);
      final int reoccuranceMin = int.parse(reoccuranceMinController.text);

      if (sheduledTime == now) {
        sheduledTime = sheduledTime.add(const Duration(minutes: 1));
      }

      Reminder reminder = Reminder(remTitle, remDesc, now, sheduledTime,
          reoccuranceHour, reoccuranceMin);
      final addres = ErrorHelper().handleResult(
          await ref.read(reminderDataProvider.notifier).addData(reminder), ref);
      final motifres = ErrorHelper().handleResult(
          await NotificationService.instance.setNotificaiton(reminder), ref);
      if (addres && motifres) {
        return true;
      }
      return false;
    } else {
      SnackBarNotify()
          .getSnackbar(context, 'Buddy.. \nGottaFill all before Adding');
      return false;
    }
  }
}
