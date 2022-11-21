import 'package:flutter/material.dart';

class ListItem {

  String title;
  String? description;
  IconData icon;
  String? routerLink;

  ListItem({required this.title, this.description, required this.icon, this.routerLink});


}

final List<ListItem> homeItemsList  = [
  ListItem(title: 'Tokoloho Articles', description: 'Lipsum', icon: Icons.description_outlined, routerLink: '/articles'),
  ListItem(title: 'FAQ', description: 'Frequently Asked Questions', icon: Icons.forum_outlined, routerLink: '/faq'),
  ListItem(title: 'Tokoloho Guides', description: 'Basic Information about HIV/AIDS & TB', icon: Icons.shortcut_outlined, routerLink: '/guides'),
  ListItem(title: 'Events', description: 'Lipsum', icon: Icons.calendar_today_outlined, routerLink: '/events'),
  ListItem(title: 'Medicine pick up dates', description: 'Lipsum', icon: Icons.medication_outlined, routerLink: '/pick_up_dates')
];

final List<ListItem> bottomNavbarItems = [
  ListItem(title: 'Home', icon: Icons.home_outlined, routerLink: '/'),
  ListItem(title: 'Search', icon: Icons.search, routerLink: '/search'),
  ListItem(title: 'Favorites', icon: Icons.favorite_border_outlined, routerLink: '/favorites'),
  ListItem(title: 'Settings', icon: Icons.settings_outlined, routerLink: '/settings')
];