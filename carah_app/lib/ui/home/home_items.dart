import 'package:flutter/material.dart';

class ListItem {

  String title;
  String description;
  IconData icon;
  String? redirectLink;

  ListItem({required this.title, required this.description, required this.icon, this.redirectLink});


}

final List<ListItem> homeItemsList  = [
  ListItem(title: 'Tokoloho Articles', description: 'Lipsum', icon: Icons.description),
  ListItem(title: 'FAQ', description: 'Frequently Asked Questions', icon: Icons.forum),
  ListItem(title: 'Tokoloho Guides', description: 'Basic Information about HIV/AIDS & TB', icon: Icons.shortcut_outlined),
  ListItem(title: 'Events', description: 'Lipsum', icon: Icons.calendar_today_outlined),
  ListItem(title: 'Medicine pick up dates', description: 'Lipsum', icon: Icons.medication_outlined)
];