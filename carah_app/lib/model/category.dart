import 'package:hive_flutter/hive_flutter.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category{
  @HiveField(0)
  String uuid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;

  Category({required this.uuid, required this.name, this.description});

  Category.fromJson(Map<String, dynamic> json) :
    uuid = json['uuid'] ?? json['uuid'],
    name = json['fields']['Name'] ?? json['fields']['Name'],
    description = json['fields']['Description'] ?? json['fields']['Description'];

}