import 'package:carah_app/ui/home/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class BottomNavbar extends StatelessWidget {
  int currIndex = 0;

  BottomNavbar({super.key, required this.currIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        currIndex = index;
      },
      selectedIndex: currIndex,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: bottomNavbarItems
          .map((element) => NavigationDestination(
          icon: Icon(element.icon, size: 40.0), label: element.title))
          .toList(),

    );
  }
}

