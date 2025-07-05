// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 2;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      service: fields[0] as Service,
      date: fields[1] as DateTime,
      location: fields[2] as String,
      userCount: fields[3] as int,
      userId: fields[4] as String,
      hour: fields[5] as int,
      minute: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.service)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.userCount)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.hour)
      ..writeByte(6)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
