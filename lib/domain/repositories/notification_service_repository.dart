import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/models/result/result.dart';

abstract class NotificationServiceRepositroy {
  Future<Result<bool>> initializeNotification();

  Future<Result<bool>> cancelNotification(Reminder reminder);

  Future<Result<bool>> setNotificaiton(Reminder reminder);
}
