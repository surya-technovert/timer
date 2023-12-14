// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 0;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as DateTime,
      fields[8] as int,
      fields[7] as int,
      fields[6] as bool,
    )
      ..id = fields[0] as int
      ..nextOccurance = fields[5] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.sheduledTime)
      ..writeByte(5)
      ..write(obj.nextOccurance)
      ..writeByte(6)
      ..write(obj.isOnWeekDays)
      ..writeByte(7)
      ..write(obj.reoccuranceMin)
      ..writeByte(8)
      ..write(obj.reoccuranceHour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
