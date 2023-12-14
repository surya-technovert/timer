import 'dart:io';

import 'package:Reminder/data/local_storage/database_constants.dart';
import 'package:Reminder/domain/services/data_services.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/models/reminder/reminder/reminder.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final HiveInterface _hive = Hive;
  static final DatabaseHelper instance = DatabaseHelper._();
  Box<Reminder>? _box;
  Future<Box<Reminder>> get box async {
    if (_box == null) {
      await DataServices.instance.intializeDatabase();
    }
    _box = _hive.box<Reminder>(DatabaseConstants.storeName);
    return _box!;
  }

  static Future<void> init({
    required Future<void> Function(HiveInterface hive) registerAdapterAndOpen,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, DatabaseConstants.storeName);
    if (!(await Directory(path).exists())) {
      await Directory(path).create();
    }
    _hive.init(path);

    await registerAdapterAndOpen(_hive);
  }

  // Future<void> createDatabase() async {
  //   try {
  //     if (!_hive.isAdapterRegistered(0)) {
  //       _hive
  //         ..init((await getApplicationDocumentsDirectory()).path)
  //         ..registerAdapter(ReminderAdapter());
  //     }
  //     _box = await _hive.openBox<Reminder>(DatabaseConstants.storeName);
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  Future<List<Reminder>> readData() async {
    try {
      Box<Reminder> box_ = await box;
      final values = box_.values.toList();
      for (var e in values) {
        print(e.nextOccurance.toString());
      }

      return values;
    } on Exception {
      rethrow;
    }
  }

  Future<Reminder> getReminder(int id) async {
    try {
      Box box_ = await box;
      final output = await box_.get(id);
      return output;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> addData(Reminder reminder) async {
    try {
      Box box_ = await box;
      await box_.put(reminder.id, reminder);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> updateNextOcurrance(Reminder reminder) async {
    try {
      Box box_ = await box;
      await box_.put(reminder.id, reminder);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> deleteData(Reminder reminder) async {
    try {
      Box box_ = await box;
      await box_.delete(reminder.id);
      return true;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> ifReminderExist(int reminderid) async {
    try {
      Box box_ = await box;
      return box_.values.any((e) => e.id == reminderid);
    } on Exception {
      rethrow;
    }
  }
}
