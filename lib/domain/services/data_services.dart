import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/data/local_storage/cache_adapters.dart';
import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/data/local_storage/database_helper.dart';
import 'package:Reminder/domain/repositories/data_service_repository.dart';
import 'package:hive/hive.dart';

class DataServices implements DataServiceRepository {
  DataServices._();
  static final DataServices instance = DataServices._();

  @override
  Future<Result<bool>> intializeDatabase() async {
    try {
      await DatabaseHelper.init(
          registerAdapterAndOpen: (HiveInterface hive) =>
              CacheDtoAdapters.call(hive));
      return const Success(true);
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<Reminder>> getReminder(int id) async {
    try {
      if (await DatabaseHelper.instance.ifReminderExist(id)) {
        return Success(await DatabaseHelper.instance.getReminder(id));
      }
      return Failure(Exception('DatabaseError'), StackTrace.current);
    } on Exception catch (ex, st) {
      print(ex.toString());
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<bool>> updateNextOccurance(Reminder reminder) async {
    try {
      return Success(
          await DatabaseHelper.instance.updateNextOcurrance(reminder));
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<List<Reminder>>> getall() async {
    try {
      return Success(await DatabaseHelper.instance.readData());
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<bool>> add(Reminder reminder) async {
    try {
      return Success(await DatabaseHelper.instance.addData(reminder));
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }

  @override
  Future<Result<bool>> delete(Reminder reminder) async {
    try {
      if (await DatabaseHelper.instance.ifReminderExist(reminder.id)) {
        return Success(await DatabaseHelper.instance.deleteData(reminder));
      }
      return Failure(Exception('DatabaseError'), StackTrace.current);
    } on Exception catch (ex, st) {
      return Failure(ex, st);
    }
  }
}
