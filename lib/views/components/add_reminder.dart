import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:reminder_app/controllers/reoccurance_controller.dart';
import 'package:reminder_app/controllers/start_time_controller.dart';
import 'package:reminder_app/helpers/db_helper.dart';
import 'package:reminder_app/helpers/notification_helper.dart';
import 'package:reminder_app/modals/reminder.dart';

addReminder(context) {
  StartTimeController startTimeController = Get.find();
  ReoccuranceController reoccuranceController = Get.find();

  final key = GlobalKey<FormState>();
  String title = "";
  String description = "";
  String hour = "0";
  String minute = "0";

  Get.bottomSheet(
    BottomSheet(
      enableDrag: true,
      onClosing: () {
        startTimeController.clearDateTime();
      },
      builder: (context) => Container(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Add Reminder",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autofocus: true,
                  decoration: textFiledDecoration(
                      label: "Title", hint: "Enter Reminder title hear"),
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Title First" : null,
                  onSaved: (val) {
                    title = val!;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: textFiledDecoration(
                      label: "Description", hint: "Enter Description hear"),
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter Description First" : null,
                  onSaved: (val) {
                    description = val!;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: textFiledDecoration(
                      label: "Reoccurnace hour",
                      hint: "Enter Reoccurnace hour hear"),
                  validator: (val) => (int.parse(val!) > 20)
                      ? "Enter Reoccurance Hour correctly"
                      : null,
                  onSaved: (val) {
                    hour = val!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: textFiledDecoration(
                      label: "Reoccurance minute",
                      hint: "Enter Reoccurnace Minute hear"),
                  validator: (val) => (int.parse(val!) > 60)
                      ? "Enter Reoccurance Minute correctly"
                      : null,
                  onSaved: (val) {
                    minute = val!;
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        dateTimePicker(context, startTimeController);
                      },
                      icon: const Icon(Icons.watch_later_outlined),
                    ),
                    Expanded(
                      child: Obx(
                        () => (startTimeController.hour.value != 0)
                            ? Text(
                                "${(startTimeController.hour.value > 12) ? startTimeController.hour.value - 12 : startTimeController.hour.value}:${startTimeController.minute.value} ${(startTimeController.hour.value > 12) ? "PM" : "AM"}",
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            : const Text(""),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          key.currentState!.save();
                          reoccuranceController.setDateTime(
                              hourVal: int.tryParse(hour)!,
                              minuteVal: int.tryParse(minute)!);

                          if (startTimeController.hour.value != 0) {
                            Reminder reminder = Reminder(
                                title: title,
                                description: description,
                                hour: reoccuranceController.hour.value,
                                minute: reoccuranceController.minute.value,
                                startHour: startTimeController.hour.value,
                                startMinute: startTimeController.minute.value);
                            NotificationHelper.notificationHelper
                                .scheduleNotification(reminder: reminder);
                            DBHelper.dbHelper.insertRecord(reminder: reminder);
                            startTimeController.clearDateTime();
                            Get.back();
                          }
                        }
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

dateTimePicker(context, reminderController) {
  showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  ).then((TimeOfDay? value1) {
    if (value1 != null) {
      reminderController.setDateTime(
          hourVal: value1.hour, minuteVal: value1.minute);
    }
  });
}

textFiledDecoration({required String label, required String hint}) {
  return InputDecoration(
    label: Text(label),
    contentPadding: const EdgeInsets.all(15),
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
