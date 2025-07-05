import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:random_string/random_string.dart';
import 'signup.event.dart';
import 'signup.state.dart';
import '../../models/user.model.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading());

      try {
        final box = await Hive.openBox<AppUser>('users');
        // Kiểm tra email đã tồn tại chưa
        final existing = box.values.any((user) => user.email == event.email);

        if (existing) {
          emit(SignUpFailure("Email đã tồn tại"));
          return;
        }

        final newUser = AppUser(
          id: randomAlphaNumeric(10),
          email: event.email,
          name: event.name,
          password: event.password,
        );

        await box.add(newUser);

        // Save session data when signup is successful
        final sessionBox = await Hive.openBox('sessionBox');
        await sessionBox.put('currentUserId', newUser.id);

        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure("Lỗi: ${e.toString()}"));
      }
    });
  }
}
