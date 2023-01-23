import 'package:hive_flutter/hive_flutter.dart';

part 'content.g.dart';

@HiveType(typeId: 2)
class Content{
  @HiveField(0)
  String  uuid;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
  @HiveField(3)
  String category;
  @HiveField(4)
  bool downloaded = false;
  @HiveField(5)
  bool saved = false;

  Content({required this.uuid, required this.title, required this.content, required this.category});

  Content.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] ?? "",
        title = json['fields']['Display_Name'] ?? "",
        content = json['fields']['Html_Text'] ?? "",
        category = json['parentNode']['displayName'] ?? "";
}