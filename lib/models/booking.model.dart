import 'package:hive/hive.dart';
import 'service.model.dart';

part 'booking.model.g.dart';

@HiveType(typeId: 2)
class Booking extends HiveObject {
  @HiveField(0)
  final Service service;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  String location;

  @HiveField(3)
  int userCount;

  @HiveField(4)
  final String userId;

  @HiveField(5)
  final int hour;

  @HiveField(6)
  final int minute;

  Booking({
    required this.service,
    required this.date,
    required this.location,
    required this.userCount,
    required this.userId,
    required this.hour,
    required this.minute,
  });

  String get time => "$hour:${minute.toString().padLeft(2, '0')}";
}
