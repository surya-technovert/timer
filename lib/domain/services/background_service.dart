import 'dart:ui';
import 'package:Reminder/core/models/reminder/isolate_helper/isolate_helper.dart';
import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/domain/services/data_services.dart';
import 'package:Reminder/domain/services/notification_service.dart';

class BackGroundService {
  @pragma('vm:entry-point')
  static Future<void> sheduleNotify(int id) async {
    Result res = await DataServices.instance.getReminder(id);
    if (res is Success) {
      Reminder reminderCurrent = (res).value;
      NotificationService.showNotification(
          id: reminderCurrent.id,
          title: '${reminderCurrent.title}  Reoccurance Starts',
          description: reminderCurrent.description);
      print(res.toString() + DateTime.now().toString());
      await updateNextOccurance(id);
      await NotificationService.sheduleaRecurrentNotification(reminderCurrent);
    } else {
      print(
          "sheduleNotify Errrorrrrrrrrrrrrrrrrrrrrrrrrrrrr${(res as Failure).exception}");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> recurrentNotify(int id) async {
    Result res = await DataServices.instance.getReminder(id);
    if (res is Success) {
      Reminder reminderCurrent = res.value;
      await updateNextOccurance(id);
      NotificationService.showNotification(
          id: reminderCurrent.id,
          title: reminderCurrent.title,
          description: reminderCurrent.description);
    } else {
      print(
          " recurrentNotify Errrorrrrrrrrrrrrrrrrrrrrrrrrrrrr${(res as Failure).exception}");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> updateNextOccurance(int reminderid,
      {DateTime? nextOccurance}) async {
    Reminder reminder =
        (await DataServices.instance.getReminder(reminderid) as Success).value;
    if (nextOccurance != null) {
      reminder.nextOccurance = nextOccurance;
    } else {
      reminder.nextOccurance = reminder.nextOccurance.add(Duration(
          hours: reminder.reoccuranceHour, minutes: reminder.reoccuranceMin));
    }
    //adding updated reminder to Database.
    Result res = await DataServices.instance.updateNextOccurance(reminder);
    if (res is Success) {
      IsolateHelper.uiSendPort ??=
          IsolateNameServer.lookupPortByName(IsolateHelper.isolateName);
      IsolateHelper.uiSendPort?.send(true);
    }
  }
}
