import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'auth.event.dart';
import 'auth.state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final sessionBox = await Hive.openBox('sessionBox');
      final userId = sessionBox.get('currentUserId');
      if (userId != null) {
        emit(Authenticated(userId));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      final sessionBox = await Hive.openBox('sessionBox');
      await sessionBox.put('currentUserId', event.userId);
      emit(Authenticated(event.userId));
    });

    on<LoggedOut>((event, emit) async {
      final sessionBox = await Hive.openBox('sessionBox');
      await sessionBox.delete('currentUserId');
      emit(Unauthenticated());
    });
  }
}