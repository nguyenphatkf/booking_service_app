// lib/models/service_model.dart
import 'package:hive/hive.dart';

part 'service.model.g.dart';

@HiveType(typeId: 1)
class Service extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  double price;

  @HiveField(3)
  double rating;

  @HiveField(4)
  String providerName;

  Service({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.providerName,
  });
}

