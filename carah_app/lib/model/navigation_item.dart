import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';

part 'navigation_item.g.dart';

@HiveType(typeId: 6)
class ListItem {
  @HiveField(0)
  String? uuid;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? icon;
  @HiveField(4)
  String? routerLink;
  @HiveField(5)
  bool availableInOfflineMode;
  @HiveField(6)
  bool isDisabled;
  @HiveField(7)
  int position;

  ListItem(
      {this.uuid,
      required this.title,
      this.description,
      required this.icon,
      this.routerLink,
      required this.availableInOfflineMode,
      required this.isDisabled,
      required this.position});

  ListItem.fromJson(Map<String, dynamic> json):
    title = json['fields']?['Header'] ?? '',
    description = json['fields']?['Subheading'] ?? '',
    icon = json['fields']?['icon'],
    routerLink = json['fields']?['routerLink'],
    availableInOfflineMode = json['fields']?['isAvailableInOfflineMode'] ?? false,
    isDisabled = json['fields']?['isDisabled'] ?? true,
    position = json['fields']?['position'] ?? -1
  ;


}

final List<ListItem> bottomNavbarItems = kIsWeb
    ? [
        ListItem(
            title: 'Home',
            icon: '0xf107',
            routerLink: '/',
            availableInOfflineMode: true,
            isDisabled: false,
            position: -1),
        ListItem(
            title: 'Search',
            icon: '0xe567',
            routerLink: '/search',
            availableInOfflineMode: true,
            isDisabled: false,
            position: -1),
      ]
    : [
        ListItem(
            title: 'Home',
            icon: '0xf107',
            routerLink: '/',
            availableInOfflineMode: true,
            isDisabled: false,
            position: -1),
        ListItem(
            title: 'Search',
            icon: '0xe567',
            routerLink: '/search',
            availableInOfflineMode: true,
            isDisabled: false,
            position: -1),
        ListItem(
            title: 'Favorites',
            icon: '0xf04a',
            routerLink: '/favorites',
            availableInOfflineMode: true,
            isDisabled: false,
            position: -1),
        ListItem(
            title: 'Settings',
            icon: '0xf36e',
            routerLink: '/settings',
            availableInOfflineMode: true,
            isDisabled: false,
            position: -1),
      ];