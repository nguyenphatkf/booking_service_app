import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:service_booking/page/home.page.dart';
import 'package:service_booking/page/bookingHistory.page.dart';
import 'package:service_booking/page/profile.page.dart';
import 'package:service_booking/blocs/navigation/navigation.bloc.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final List<Widget> pages = [Home(), BookingHistoryPage(), Profile()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentTabIndex) {
          return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              height: 70,
              backgroundColor: Colors.white,
              color: Colors.black,
              animationDuration: Duration(milliseconds: 200),
              index: currentTabIndex,
              onTap: (int index) {
                context.read<NavigationCubit>().changeTab(index);
              },
              items: const [
                Icon(Icons.home_outlined, color: Colors.white, size: 20.0),
                Icon(Icons.shop_outlined, color: Colors.white, size: 20.0),
                //Icon(Icons.chat_outlined, color: Colors.white, size: 20.0), 
                Icon(Icons.person, color: Colors.white, size: 20.0),
              ],
            ),
            body: pages[currentTabIndex],
          );
        },
      ),
    );
  }
}
