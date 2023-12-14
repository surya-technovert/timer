import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/domain/services/background_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Reminder/domain/repositories/notification_service_repository.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService implements NotificationServiceRepositroy {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<Result<bool>> initializeNotification() async {
    try {
      await Permission.notification.isDenied.then((value) async {
        if (value) {
          Permission.notification.request();
        }
      });
      _configureLocalTimeZone();
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/icon');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        iOS: initializationSettingsIOS,
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      return const Success(true);
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<bool>> cancelNotification(Reminder reminder) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(reminder.id);
      AndroidAlarmManager.cancel(reminder.id);
      return const Success(true);
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<bool>> setNotificaiton(Reminder reminder) async {
    try {
      bool isReoccurant =
          reminder.reoccuranceHour != 0 || reminder.reoccuranceMin != 0;

      if (!isReoccurant) {
        _scheduledNotification(
            id: reminder.id,
            title: reminder.title,
            description: reminder.description,
            scheduleDateTime: reminder.sheduledTime,
            now: reminder.startTime);
      }

      if (isReoccurant) {
        Duration differnce = (reminder.sheduledTime).difference(DateTime.now());
        //using DateTime.now() to avoid latency..
        while (differnce.isNegative) {
          Duration nextOccurance = differnce +
              Duration(
                  hours: reminder.reoccuranceHour,
                  minutes: reminder.reoccuranceMin);
          differnce = (reminder.sheduledTime.add(nextOccurance))
              .difference(DateTime.now());
        }

        await BackGroundService.updateNextOccurance(reminder.id,
            nextOccurance: reminder.sheduledTime.add(differnce));

        await AndroidAlarmManager.oneShot(
          differnce,
          reminder.id,
          BackGroundService.sheduleNotify,
          rescheduleOnReboot: true,
          exact: true,
          wakeup: true,
        );
      }
      return (const Success(true));
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  static sheduleaRecurrentNotification(Reminder reminder) async {
    //await BackGroundService.recurrentNotify(reminder.id);
    AndroidAlarmManager.periodic(
      Duration(
          hours: reminder.reoccuranceHour, minutes: reminder.reoccuranceMin),
      reminder.id,
      BackGroundService.recurrentNotify,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
  }

  static showNotification({
    required int id,
    required String title,
    required String description,
  }) {
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'Timely Notifier notify_sound',
          'Timely Notifier',
          channelDescription: 'To give a timely notificaiton as per shedule',
          importance: Importance.max,
          priority: Priority.high,
          //sound: RawResourceAndroidNotificationSound('notify_sound'),
        ),
        iOS: DarwinNotificationDetails(sound: 'notify_sound.mp3'),
      ),
    );
  }

  Future<void> _scheduledNotification({
    required int id,
    required String title,
    required String description,
    required DateTime scheduleDateTime,
    required DateTime now,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      description,
      _convertToTZ(scheduleDateTime, now),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'Timely Notifier notify_sound',
          'Timely Notifier',
          channelDescription: 'To give a timely notificaiton as per shedule',
          importance: Importance.max,
          priority: Priority.high,
          //sound: RawResourceAndroidNotificationSound('notify_sound'),
        ),
        iOS: DarwinNotificationDetails(sound: 'notify_sound.mp3'),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'For now NULL',
    );
  }

  tz.TZDateTime _convertToTZ(DateTime dateTime, DateTime nowDateTime) {
    //final tz.TZDateTime now = tz.TZDateTime.from(nowDateTime, tz.local);
    tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    // if (tzDateTime.isBefore(now)) {
    //   tzDateTime = tzDateTime.add(const Duration(days: 1));
    // }
    return tzDateTime;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
  // tz.TZDateTime _convertTime(int hour, int minutes, DateTime dateTime) {
  //   final tz.TZDateTime now = tz.TZDateTime.from(dateTime, tz.local);
  //   tz.TZDateTime scheduleDate = tz.TZDateTime(
  //     tz.local,
  //     now.year,
  //     now.month,
  //     now.day,
  //     now.hour + hour,
  //     now.minute + minutes,
  //   );
  //   return _convertToTZ(scheduleDate, dateTime);
  // }
}
