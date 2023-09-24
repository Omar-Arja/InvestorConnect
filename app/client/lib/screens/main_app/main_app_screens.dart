import 'package:flutter/material.dart';
import 'package:client/widgets/bottom_navbar.dart';
import 'package:client/screens/main_app/home_screen.dart';
import 'package:client/screens/main_app/messages/chats_screen.dart';
import 'package:client/screens/main_app/calendar_screen.dart';
import 'package:client/screens/main_app/notifications_screen.dart';
import 'package:client/screens/main_app/profile/profile_screen.dart';

class MainAppScreens extends StatefulWidget {
  const MainAppScreens({super.key});

  @override
  _MainAppScreensState createState() => _MainAppScreensState();
}

class _MainAppScreensState extends State<MainAppScreens> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      extendBody: true,
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ChatsScreen();
      case 2:
        return const CalendarScreen();
      case 3:
        return const NotificationsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
