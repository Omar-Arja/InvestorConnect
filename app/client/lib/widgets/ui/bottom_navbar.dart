import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: const Color.fromARGB(255, 31, 40, 65),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavItem(0, Icons.home_outlined, 37),
          buildNavItem(1, Icons.messenger_outline_outlined, 34, margin: 5),
          buildNavItem(2, Icons.calendar_today_outlined, 32),
          buildNavItem(3, Icons.notifications_outlined, 35),
          buildNavItem(4, Icons.person_outline_rounded, 35),
        ],
      ),
    );
  }

  Widget buildNavItem(int index, IconData icon, double iconSize, {double? margin}) {
    final isActive = index == selectedIndex;
    final opacity = isActive ? 1.0 : 0.25;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(top: margin ?? 0),
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}
