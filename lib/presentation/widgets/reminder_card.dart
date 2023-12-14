import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/services/notification_service.dart';
import 'package:Reminder/presentation/utils/extensions/context_extensions.dart';
import 'package:Reminder/presentation/providers/value_providers/data_provider.dart';
import 'package:Reminder/presentation/utils/helper_widgets_functions/error_helpers/error_helper.dart';

class ReminderCard extends ConsumerStatefulWidget {
  final Reminder data;

  const ReminderCard({super.key, required this.data});

  @override
  ConsumerState<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends ConsumerState<ReminderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Dismissible(
          key: UniqueKey(),
          confirmDismiss: (direction) async {
            return await _displayDeleteAlert(context);
          },
          onDismissed: (direction) {},
          background: _displayTileBackground(),
          direction: DismissDirection.endToStart,
          child: _displayListTile(context)),
    );
  }

  Container _displayTileBackground() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Colors.transparent,
            Colors.red,
          ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.decal)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Delete',
              style: TextStyle(
                  fontFamily: 'Crimson',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white)),
          SizedBox(
            width: 15,
          ),
          Icon(
            CupertinoIcons.delete,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  Container _displayListTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [context.primartyColor, context.inversePrimary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp)),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 10, color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: const Icon(
          CupertinoIcons.timer_fill,
          size: 30,
          color: Colors.white,
        ),
        title: Text(
          widget.data.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontFamily: 'Crimson',
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.description,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: 'Crimson',
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                  color: Colors.white),
            ),
            Text(
              '${(widget.data.reoccuranceHour).toString().padLeft(2, '0')} : ${(widget.data.reoccuranceMin).toString().padLeft(2, '0')} - Reoccurance',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontFamily: 'Crimson',
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                  color: Colors.white),
            ),
          ],
        ),
        trailing: Text(
          'Next Occurance -  ${(widget.data.nextOccurance.hour).toString().padLeft(2, '0')} : ${(widget.data.nextOccurance.minute).toString().padLeft(2, '0')} ',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontFamily: 'Crimson',
              fontWeight: FontWeight.w800,
              fontSize: 15.0,
              color: Colors.white),
        ),
      ),
    );
  }

  Future<bool?> _displayDeleteAlert(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              'Are you sure you want to delete the Reminder: ${widget.data.title}'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () => {
                (_deleteReminder(widget.data)).then((value) => (value)
                    ? Navigator.pop(context, true)
                    : Navigator.pop(context, false))
              },
            ),
            ElevatedButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deleteReminder(Reminder reminder) async {
    final datares = ErrorHelper().handleResult(
        await ref.read(reminderDataProvider.notifier).deleteData(reminder),
        ref);
    final notres = ErrorHelper().handleResult(
        await NotificationService.instance.cancelNotification(reminder), ref);
    if (datares && notres) {
      return true;
    }
    return false;
  }
}
