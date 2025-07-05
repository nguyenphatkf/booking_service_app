import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/user.model.dart';
import 'login.event.dart';
import 'login.state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final box = await Hive.openBox<AppUser>('users');
        final user = box.values.firstWhere(
          (user) => user.email == event.email,
          orElse: () => throw Exception('Không tìm thấy người dùng'),
        );

        if (user.password == event.password) {
          // Save session data when login is successful
          final sessionBox = await Hive.openBox('sessionBox');
          await sessionBox.put('currentUserId', user.id);

          emit(LoginSuccess());
        } else {
          emit(LoginFailure('Sai mật khẩu'));
        }
      } catch (e) {
        emit(LoginFailure('Đăng nhập thất bại: ${e.toString()}'));
      }
    });
  }
}
