import 'package:hive_flutter/hive_flutter.dart';
part 'reminder.g.dart';

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  static int _id = 0;
  @HiveField(0)
  late int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime startTime;
  @HiveField(4)
  DateTime sheduledTime;
  @HiveField(5)
  late DateTime nextOccurance;
  @HiveField(6)
  bool isOnWeekDays;
  @HiveField(7)
  int reoccuranceMin;
  @HiveField(8)
  int reoccuranceHour;

  Reminder(this.title, this.description, this.startTime, this.sheduledTime,
      [this.reoccuranceHour = 0,
      this.reoccuranceMin = 0,
      this.isOnWeekDays = false]) {
    _id++;
    id = _id;
    nextOccurance = sheduledTime;
  }
}
