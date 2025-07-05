import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../models/user.model.dart';
import 'profile.event.dart';
import 'profile.state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final sessionBox = await Hive.openBox('sessionBox');
        final userId = sessionBox.get('currentUserId');

        final usersBox = await Hive.openBox<AppUser>('users');
        final user = usersBox.values.firstWhere((u) => u.id == userId);

        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError('Lỗi tải hồ sơ: ${e.toString()}'));
      }
    });

    on<UpdateProfileName>((event, emit) async {
      try {
        final sessionBox = await Hive.openBox('sessionBox');
        final userId = sessionBox.get('currentUserId');
        final usersBox = await Hive.openBox<AppUser>('users');

        final user = usersBox.values.firstWhere((u) => u.id == userId);
        user.name = event.newName;
        await user.save();

        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError('Không thể cập nhật tên'));
      }
    });

    on<LogoutProfile>((event, emit) async {
      final sessionBox = await Hive.openBox('sessionBox');
      await sessionBox.delete('currentUserId');
      emit(ProfileLogoutSuccess());
    });
  }
}
