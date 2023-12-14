import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:reminder_app/controllers/reoccurance_controller.dart';
import 'package:reminder_app/controllers/start_time_controller.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:reminder_app/modals/reminder_db.dart';

import 'package:reminder_app/utils/database_constants.dart';
import 'package:sqflite/sqflite.dart';

ReoccuranceController reoccuranceController = Get.put(ReoccuranceController());
StartTimeController startTimeController = Get.put(StartTimeController());

class DBHelper {
  DBHelper._();

  static final DBHelper dbHelper = DBHelper._();

  Database? db;

  Future<void> initDB() async {
    String directory = await getDatabasesPath();
    String path = join(directory, DatabaseConstants.dbName);

    db = await openDatabase(path, version: 1, onCreate: (db, version) {});

    await db?.execute(
        "CREATE TABLE IF NOT EXISTS ${DatabaseConstants.tableName} (${DatabaseConstants.id} INTEGER,${DatabaseConstants.title} TEXT,${DatabaseConstants.description} TEXT,${DatabaseConstants.hour} INTEGER,${DatabaseConstants.minute} INTEGER,${DatabaseConstants.startHour} INTEGER,${DatabaseConstants.startMinute} INTEGER)");
  }

  insertRecord({required Reminder reminder}) async {
    await initDB();
    String query =
        "INSERT INTO ${DatabaseConstants.tableName} (${DatabaseConstants.id}, ${DatabaseConstants.title}, ${DatabaseConstants.description}, ${DatabaseConstants.hour}, ${DatabaseConstants.minute}, ${DatabaseConstants.startHour}, ${DatabaseConstants.startMinute}) VALUES(?, ?, ?, ?, ?, ?, ?)";
    List args = [
      reminder.id,
      reminder.title,
      reminder.description,
      reminder.hour,
      reminder.minute,
      reminder.startHour,
      reminder.startMinute,
    ];
    await db?.rawInsert(query, args);
    fetchAllRecords();
  }

  Future fetchAllRecords() async {
    await initDB();

    String query = "SELECT * FROM ${DatabaseConstants.tableName} ";

    List<Map<String, dynamic>> data = await db!.rawQuery(query);

    List<ReminderDB> reminderList =
        data.map((e) => ReminderDB.fromData(data: e)).toList();

    reoccuranceController.reminders.value = reminderList;

    reoccuranceController.reminders.value.sort((a, b) {
      int minute = (a.minute > 9) ? a.minute : int.parse("0${a.minute}");
      int minute2 = (b.minute > 9) ? b.minute : int.parse("0${b.minute}");

      return (int.parse("${a.hour}$minute"))
          .compareTo(int.parse("${b.hour}$minute2"));
    });

    startTimeController.reminders.value = reminderList;

    startTimeController.reminders.value.sort((a, b) {
      int minute =
          (a.startMinute > 9) ? a.startMinute : int.parse("0${a.startMinute}");
      int minute2 =
          (b.startMinute > 9) ? b.startMinute : int.parse("0${b.startMinute}");

      return (int.parse("${a.hour}$minute"))
          .compareTo(int.parse("${b.hour}$minute2"));
    });

    return reminderList;
  }

  Future updateReminder({required ReminderDB reminder}) async {
    await initDB();

    String query =
        "UPDATE ${DatabaseConstants.tableName} SET ${DatabaseConstants.title} = ?, ${DatabaseConstants.description} = ?, ${DatabaseConstants.minute} = ? ,${DatabaseConstants.hour} = ? , ${DatabaseConstants.startHour} = ? , ${DatabaseConstants.startMinute} = ? ${DatabaseConstants.id} = ?";
    List args = [
      reminder.title,
      reminder.description,
      reminder.minute,
      reminder.hour,
      reminder.startHour,
      reminder.startMinute,
      reminder.id,
    ];
    await db!.rawUpdate(query, args);

    fetchAllRecords();
  }

  deleteReminder({required int id}) async {
    await initDB();

    String query =
        "DELETE FROM ${DatabaseConstants.tableName} WHERE ${DatabaseConstants.id} = $id";

    db!.rawDelete(query);

    fetchAllRecords();
  }
}
