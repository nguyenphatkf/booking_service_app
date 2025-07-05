abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpSubmitted({required this.name, required this.email, required this.password});
}
