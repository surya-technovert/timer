import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/repositories/data_service_repository.dart';
import 'package:Reminder/domain/repositories/notification_service_repository.dart';
import 'package:Reminder/domain/services/data_services.dart';
import 'package:Reminder/domain/services/notification_service.dart';

class ReminderRunUseCase {
  ReminderRunUseCase._();
  static final ReminderRunUseCase instance = ReminderRunUseCase._();
  final DataServiceRepository dataServiceRepository = DataServices.instance;
  final NotificationServiceRepositroy notificationServiceRepositroy =
      NotificationService.instance;

  Future<bool> setReminder(Reminder reminder) async {
    notificationServiceRepositroy.setNotificaiton(reminder);
    return true;
  }
}
