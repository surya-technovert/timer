import 'dart:ui';

import 'package:Reminder/core/models/reminder/isolate_helper/isolate_helper.dart';
import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/domain/repositories/data_service_repository.dart';
import 'package:Reminder/domain/repositories/notification_service_repository.dart';
import 'package:Reminder/domain/services/data_services.dart';
import 'package:Reminder/domain/services/notification_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class InitializeUseCase {
  InitializeUseCase._();
  static final InitializeUseCase instance = InitializeUseCase._();

  final DataServiceRepository dataServiceRepository = DataServices.instance;
  final NotificationServiceRepositroy notificationServiceRepositroy =
      NotificationService.instance;

  Future<Result<bool>> initializeAppRequirements() async {
    try {
      Result<bool> databaseRes =
          await DataServices.instance.intializeDatabase();
      Result<bool> notifyRes =
          await notificationServiceRepositroy.initializeNotification();
      await AndroidAlarmManager.initialize();
      IsolateNameServer.registerPortWithName(
        IsolateHelper.port.sendPort,
        IsolateHelper.isolateName,
      );

      if ((databaseRes as Success).value && (notifyRes as Success).value) {
        return databaseRes;
      }
      return Failure(Exception('Intialization Error'), StackTrace.current);
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }
}
