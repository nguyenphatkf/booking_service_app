abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileName extends ProfileEvent {
  final String newName;
  UpdateProfileName(this.newName);
}

class LogoutProfile extends ProfileEvent {}
