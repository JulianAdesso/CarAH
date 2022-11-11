import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {

  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home'),
        BottomNavigationBarItem(icon:
        Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon:
        Icon(Icons.favorite_border_outlined), label: 'Favorites'),
        BottomNavigationBarItem(icon:
        Icon(Icons.settings_outlined), label: 'Settings')
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade300,
    );
  }
}
