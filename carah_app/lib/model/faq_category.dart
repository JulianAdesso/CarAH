import 'package:hive_flutter/hive_flutter.dart';

part 'faq_category.g.dart';

@HiveType(typeId: 3)
class FAQCategory{
  @HiveField(0)
  String uuid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;

  FAQCategory({required this.uuid, required this.name, this.description});

  FAQCategory.fromJson(Map<String, dynamic> json) :
        uuid = json['uuid'] ?? json['uuid'],
        name = json['fields']['Name'] ?? json['fields']['Name'],
        description = json['fields']['Description'] ?? json['fields']['Description'];

}