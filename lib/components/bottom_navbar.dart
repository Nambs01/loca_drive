// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  Function(int)? onTabChange;
  MyBottomNavbar({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(10),
      child: GNav(
        selectedIndex: selectedIndex,
        color: Colors.grey.shade400,
        activeColor: color.primary,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        gap: 8,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            icon: Icons.list_outlined,
            text: "Liste",
          ),
          GButton(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            icon: Icons.bar_chart_outlined,
            text: "Histogramme",
          ),
        ],
      ),
    );
  }
}
