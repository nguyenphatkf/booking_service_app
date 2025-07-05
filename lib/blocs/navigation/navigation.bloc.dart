import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:service_booking/page/chat.page.dart';
import 'package:service_booking/page/home.page.dart';
import 'package:service_booking/page/order.page.dart';
import 'package:service_booking/page/profile.page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // Tab đầu tiên (Home)

  void changeTab(int index) => emit(index);
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home homePage;
  late Order order;
  late ChatPage chatPage;
  late Profile profile;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = Home();
    order = Order();
    chatPage = ChatPage();
    profile = Profile();
    pages = [homePage, order, chatPage, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(microseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white, size: 20.0),
          Icon(Icons.shop_outlined, color: Colors.white, size: 20.0),
          Icon(Icons.chat_outlined, color: Colors.white, size: 20.0),
          Icon(Icons.person, color: Colors.white, size: 20.0),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
