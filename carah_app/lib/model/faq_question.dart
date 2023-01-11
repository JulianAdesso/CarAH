import 'package:hive_flutter/hive_flutter.dart';

part 'faq_question.g.dart';

@HiveType(typeId: 4)
class Question{
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
  @HiveField(6)
  List<String> ?imageId;

 Question({required this.uuid, required this.title, required this.content, required this.category});

  Question.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] ?? json['uuid'],
        title = json['fields']['Display_Name'] ?? json['fields']['Display_Name'],
        content = json['fields']['Html_Text'] ?? json['fields']['Html_Text'],
        category = json['parentNode']['displayName'] ?? json['parentNode']['displayName'],
        imageId = (json['fields']['images'] as List?)?.map((item) => item.toString())?.toList();
}