import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ListItem {
  String? uuid;
  String title;
  String? description;
  IconData icon;
  String? routerLink;
  bool availableInOfflineMode;

  ListItem(
      {this.uuid,
      required this.title,
      this.description,
      required this.icon,
      this.routerLink,
      required this.availableInOfflineMode});
}

final List<ListItem> homeItemsList = [
  ListItem(
      title: 'Tokoloho Articles',
      description: '',
      icon: Icons.article_outlined,
      routerLink: '/articles_categories',
      availableInOfflineMode: true),
  ListItem(
      title: 'FAQ',
      description: 'Frequently Asked Questions',
      icon: Icons.forum_outlined,
      routerLink: '/faq_categories',
      availableInOfflineMode: false),
  ListItem(
      title: 'Tokoloho Guides',
      description: 'Coming soon!',
      icon: Icons.directions_outlined,
      routerLink: null,
      availableInOfflineMode: false),
  ListItem(
      title: 'Events',
      description: 'Coming soon!',
      icon: Icons.event_outlined,
      routerLink: null,
      availableInOfflineMode: false),
  ListItem(
      title: 'Medicine pick up dates',
      description: 'Coming soon!',
      icon: Icons.medication_outlined,
      routerLink: null,
      availableInOfflineMode: false)
];

final List<ListItem> bottomNavbarItems = kIsWeb
    ? [
        ListItem(
            title: 'Home',
            icon: Icons.home_outlined,
            routerLink: '/',
            availableInOfflineMode: true),
        ListItem(
            title: 'Search',
            icon: Icons.search,
            routerLink: '/search',
            availableInOfflineMode: true),
      ]
    : [
        ListItem(
            title: 'Home',
            icon: Icons.home_outlined,
            routerLink: '/',
            availableInOfflineMode: true),
        ListItem(
            title: 'Search',
            icon: Icons.search,
            routerLink: '/search',
            availableInOfflineMode: true),
        ListItem(
            title: 'Favorites',
            icon: Icons.favorite_border_outlined,
            routerLink: '/favorites',
            availableInOfflineMode: true),
        ListItem(
            title: 'Settings',
            icon: Icons.settings_outlined,
            routerLink: '/settings',
            availableInOfflineMode: true),
      ];