import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/data/local_storage/database_constants.dart';
import 'package:hive/hive.dart';

class CacheDtoAdapters {
  static Future<void> call(HiveInterface hive) async {
    if (!hive.isAdapterRegistered(0)) {
      hive.registerAdapter<Reminder>(ReminderAdapter());
    }
    await hive.openBox<Reminder>(
      DatabaseConstants.storeName,
    );
  }
}
