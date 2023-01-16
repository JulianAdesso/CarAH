import 'package:hive_flutter/hive_flutter.dart';

import 'content.dart';

part 'faq_question.g.dart';

@HiveType(typeId: 4)
class Question extends Content{
  @HiveField(6)
  List<String> ?imageId;

  Question({required String uuid, required String title, required String content, required String category}) : super(uuid: uuid, title: title, content: content, category: category);

  Question.fromJson(Map<String, dynamic> json)
      : imageId = (json['fields']['images'] as List?)?.map((item) => item.toString()).toList(), super(uuid : json['uuid'] ?? "",
      title : json['fields']['Display_Name'] ?? "",
      content : json['fields']['Html_Text'] ?? "",
      category : json['parentNode']['displayName'] ?? "");
}