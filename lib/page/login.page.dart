import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_booking/page/signup.page.dart';
import 'package:service_booking/page/bottomnav.dart';
import 'package:service_booking/blocs/signin/login.bloc.dart';
import 'package:service_booking/blocs/signin/login.event.dart';
import 'package:service_booking/blocs/signin/login.state.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Đăng nhập thành công")));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BottomNav()),
              );
            } else if (state is LoginFailure) {
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
                  Image.asset("images/login.png"),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  SizedBox(height: 40),
                  state is LoginLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          if (email.isNotEmpty && password.isNotEmpty) {
                            context.read<LoginBloc>().add(
                              LoginSubmitted(email: email, password: password),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Vui lòng nhập đầy đủ")),
                            );
                          }
                        },
                        icon: Icon(Icons.login),
                        label: Text("Đăng nhập"),
                      ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Chưa có tài khoản? "),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignUp()),
                            ),
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
