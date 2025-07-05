import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_booking/blocs/profile/profile.bloc.dart';
import 'package:service_booking/blocs/profile/profile.event.dart';
import 'package:service_booking/blocs/profile/profile.state.dart';
import 'package:service_booking/page/login.page.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Login()),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            nameController.text = state.user.name;

            return Scaffold(
              appBar: AppBar(
                title: Text("Hồ sơ cá nhân"),
                backgroundColor: const Color.fromARGB(255, 6, 95, 140),
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed:
                        () => context.read<ProfileBloc>().add(LogoutProfile()),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${state.user.email}"),
                    SizedBox(height: 10),
                    Text("User ID: ${state.user.id}"),
                    SizedBox(height: 20),
                    Text("Tên của bạn:"),
                    TextField(controller: nameController),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final newName = nameController.text.trim();
                        if (newName.isNotEmpty) {
                          context.read<ProfileBloc>().add(
                            UpdateProfileName(newName),
                          );
                        }
                      },
                      child: Text("Cập nhật tên"),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
