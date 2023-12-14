class Reminder {
  static int _id = 0;

  int get _newId {
    _id++;
    return _id;
  }

  late int id;
  final String title;
  final String description;
  final int hour;
  final int minute;
  final int startHour;
  final int startMinute;

  Reminder(
      {required this.title,
      required this.description,
      required this.hour,
      required this.minute,
      required this.startHour,
      required this.startMinute}) {
    id = _newId;
  }

  Reminder.update({
    required this.id,
    required this.title,
    required this.description,
    required this.hour,
    required this.minute,
    required this.startHour,
    required this.startMinute,
  });
}
