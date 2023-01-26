
import 'content.dart';

enum ContentType {
  none,
  article,
  question
}

class SearchContent extends Content{
  late ContentType contentType;

  SearchContent({required String uuid, required String title, required String content, required String category}) : super(uuid: uuid, title: title, content: content, category: category);

  SearchContent.fromJson(Map<String, dynamic> json)
      : super(uuid : json['uuid'] ?? "",
      title : json['displayName'] ?? "",
      content : "",
      category : "");
}