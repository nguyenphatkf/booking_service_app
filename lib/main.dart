import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/auth/auth.bloc.dart';
import 'blocs/auth/auth.event.dart';
import 'blocs/auth/auth.state.dart';
import 'models/user.model.dart';
import 'models/service.model.dart';
import 'models/booking.model.dart';
import 'page/login.page.dart';
import 'page/bottomnav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AppUserAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(BookingAdapter());

  await Hive.openBox<AppUser>('users');
  await Hive.openBox<Service>('servicesBox');
  await Hive.openBox<Booking>('bookingsBox');

  runApp(
    BlocProvider(
      create: (_) => AuthBloc()..add(AppStarted()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BottomNav();
          } else if (state is Unauthenticated) {
            return Login();
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
