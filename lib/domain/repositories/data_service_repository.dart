import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/models/result/result.dart';

abstract class DataServiceRepository {
  Future<Result<bool>> delete(Reminder reminder);

  Future<Result<bool>> add(Reminder reminder);

  Future<Result<List<Reminder>>> getall();

  Future<Result<Reminder>> getReminder(int id);

  Future<Result<bool>> intializeDatabase();

  Future<Result<bool>> updateNextOccurance(Reminder reminder);
}
