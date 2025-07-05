import 'package:flutter/material.dart';
import '../../models/service.model.dart';

abstract class BookingEvent {}

class SubmitBookingWithDetails extends BookingEvent {
  final Service service;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final int userCount;

  SubmitBookingWithDetails({
    required this.service,
    required this.date,
    required this.time,
    required this.location,
    required this.userCount,
  });
}
