import 'package:hive/hive.dart';

part 'user.model.g.dart';

@HiveType(typeId: 0)
class AppUser extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String name;

  @HiveField(3)
  String password;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });
}
