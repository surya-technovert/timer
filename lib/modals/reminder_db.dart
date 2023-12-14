import '../utils/database_constants.dart';

class ReminderDB {
  final int id;
  final String title;
  final String description;
  final int hour;
  final int minute;
  final int startHour;
  final int startMinute;

  ReminderDB(
      {required this.id,
      required this.title,
      required this.description,
      required this.hour,
      required this.minute,
      required this.startHour,
      required this.startMinute});

  factory ReminderDB.fromData({required Map data}) {
    return ReminderDB(
      id: data[DatabaseConstants.id],
      title: data[DatabaseConstants.title],
      description: data[DatabaseConstants.description],
      hour: data[DatabaseConstants.hour],
      minute: data[DatabaseConstants.minute],
      startHour: data[DatabaseConstants.startHour],
      startMinute: data[DatabaseConstants.startMinute],
    );
  }
}
