import 'package:Reminder/core/models/reminder/reminder/reminder.dart';
import 'package:Reminder/domain/models/result/result.dart';
import 'package:Reminder/domain/services/data_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reminderDataProvider = ChangeNotifierProvider<ReminderDataNotifier>(
    (ref) => ReminderDataNotifier());

class ReminderDataNotifier extends ChangeNotifier {
  Result<List<Reminder>>? _reminderList;

  Future<Result<List<Reminder>>> get reminderList async {
    if (_reminderList == null) {
      await updateReminderList();
    }
    return _reminderList!;
  }

  Future<void> updateReminderList() async {
    Result<List<Reminder>> res = await DataServices.instance.getall();
    if (res is Success) {
      _reminderList = res;
      notifyListeners();
    }
  }

  Future<Result<bool>> deleteData(Reminder reminder) async {
    final res = await DataServices.instance.delete(reminder);
    if (res is Success) {
      updateReminderList();
    }
    return res;
  }

  Future<Result<bool>> addData(Reminder reminder) async {
    final res = await DataServices.instance.add(reminder);
    if (res is Success) {
      updateReminderList();
    }
    return res;
  }
}
