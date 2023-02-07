
import 'content.dart';

enum ContentType {
  none,
  article,
  question
}

class LightContent extends Content{
  late ContentType contentType;

  LightContent({required String uuid, required String title, required String content, required String category}) : super(uuid: uuid, title: title, content: content, category: category);

  LightContent.fromJson(Map<String, dynamic> json)
      : super(uuid : json['uuid'] ?? "",
      title : json['displayName'] ?? "",
      content : "",
      category : json['schema']['uuid'] ?? "");
}