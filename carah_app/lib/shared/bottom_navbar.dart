import 'package:carah_app/model/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';

class BottomNavbar extends StatelessWidget {
  int currIndex = 0;

  BottomNavbar({super.key, required this.currIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: bottomNavbarItems
          .map((element) => BottomNavigationBarItem(
              icon: Icon(element.icon != null ? IconData(int.parse(element.icon!) , fontFamily: 'MaterialIcons'): null, size: 40.0), label: element.title))
          .toList(),
      currentIndex: currIndex,
      onTap: (index) => bottomNavbarItems[index].routerLink != GoRouterState.of(context).path
          ? context.push(bottomNavbarItems[index].routerLink!)
          : null,
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: Theme.of(context).colorScheme.surfaceVariant,
      unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
