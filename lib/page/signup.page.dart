import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_booking/blocs/signup/signup.bloc.dart';
import 'package:service_booking/blocs/signup/signup.event.dart';
import 'package:service_booking/blocs/signup/signup.state.dart';
import 'package:service_booking/page/bottomnav.dart';
import 'package:service_booking/page/login.page.dart';

class SignUp extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: Scaffold(
        body: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Đăng ký thành công')));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BottomNav()),
              );
            } else if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Image.asset("images/signup.png"),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Name'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(height: 30),
                  state is SignUpLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: () {
                            final email = emailController.text.trim();
                            final name = nameController.text.trim();
                            final password = passwordController.text;

                            if (email.isNotEmpty &&
                                name.isNotEmpty &&
                                password.isNotEmpty) {
                              context.read<SignUpBloc>().add(
                                SignUpSubmitted(
                                  name: name,
                                  email: email,
                                  password: password,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Điền đầy đủ thông tin")),
                              );
                            }
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text("Dăng ký"),
                        ),
                  SizedBox(height: 10), // Thêm khoảng cách
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Login()),
                      );
                    },
                    child: Text("Quay lại đăng nhập"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
