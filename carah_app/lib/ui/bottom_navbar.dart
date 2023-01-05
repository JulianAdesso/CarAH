import 'package:carah_app/ui/home/navigation_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatelessWidget {
  int currIndex = 0;

  BottomNavbar({super.key, required this.currIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: bottomNavbarItems
          .map((element) => BottomNavigationBarItem(
              icon: Icon(element.icon, size: 40.0), label: element.title))
          .toList(),
      currentIndex: currIndex,
      onTap: (index) => index != currIndex ? context.push(bottomNavbarItems[index].routerLink!) : null,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade300,
    );
  }
}
