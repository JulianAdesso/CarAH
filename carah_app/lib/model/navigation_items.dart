import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 6)
class ListItem {
  @HiveField(0)
  String? uuid;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  IconData icon;
  @HiveField(4)
  String? routerLink;
  @HiveField(5)
  bool availableInOfflineMode;
  @HiveField(6)
  bool isDisabled;

  ListItem(
      {this.uuid,
      required this.title,
      this.description,
      required this.icon,
      this.routerLink,
      required this.availableInOfflineMode,
      required this.isDisabled});

  ListItem.fromJson(Map<String, dynamic> json):
    title = json['fields']['Header'],
    description = json['fields']['Subheading'],
    icon = IconData(int.parse(json['fields']['icon']), fontFamily: 'MaterialIcons'),
    routerLink = json['fields']['routerLink'],
    availableInOfflineMode = json['fields']['isAvailableInOfflineMode'],
    isDisabled = json['fields']['isDisabled']
  ;


}

final List<ListItem> homeItemsList = [
  ListItem(
      title: 'Tokoloho Articles',
      description: '',
      icon: Icons.article_outlined,
      routerLink: '/articles_categories',
      availableInOfflineMode: true,
      isDisabled: false),
  ListItem(
      title: 'FAQ',
      description: 'Frequently Asked Questions',
      icon: IconData(int.parse("0xf0b0"), fontFamily: 'MaterialIcons'),
      routerLink: '/faq_categories',
      availableInOfflineMode: false,
      isDisabled: false),
  ListItem(
      title: 'Tokoloho Guides',
      description: '',
      icon: Icons.directions_outlined,
      routerLink: '/guides_categories',
      availableInOfflineMode: false,
      isDisabled: false),
  ListItem(
      title: 'Events',
      description: 'Coming soon!',
      icon: Icons.event_outlined,
      routerLink: null,
      availableInOfflineMode: false,
      isDisabled: false),
  ListItem(
      title: 'Medicine pick up dates',
      description: 'Coming soon!',
      icon: Icons.medication_outlined,
      routerLink: null,
      availableInOfflineMode: false,
      isDisabled: false)
];

final List<ListItem> bottomNavbarItems = kIsWeb
    ? [
        ListItem(
            title: 'Home',
            icon: Icons.home_outlined,
            routerLink: '/',
            availableInOfflineMode: true,
            isDisabled: false),
        ListItem(
            title: 'Search',
            icon: Icons.search,
            routerLink: '/search',
            availableInOfflineMode: true,
            isDisabled: false),
      ]
    : [
        ListItem(
            title: 'Home',
            icon: Icons.home_outlined,
            routerLink: '/',
            availableInOfflineMode: true,
            isDisabled: false),
        ListItem(
            title: 'Search',
            icon: Icons.search,
            routerLink: '/search',
            availableInOfflineMode: true,
            isDisabled: false),
        ListItem(
            title: 'Favorites',
            icon: Icons.favorite_border_outlined,
            routerLink: '/favorites',
            availableInOfflineMode: true,
            isDisabled: false),
        ListItem(
            title: 'Settings',
            icon: Icons.settings_outlined,
            routerLink: '/settings',
            availableInOfflineMode: true,
            isDisabled: false),
      ];