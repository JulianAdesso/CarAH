
import 'content.dart';



class SearchArticle extends Content{

  SearchArticle({required String uuid, required String title, required String content, required String category}) : super(uuid: uuid, title: title, content: content, category: category);

  SearchArticle.fromJson(Map<String, dynamic> json)
      : super(uuid : json['uuid'] ?? "",
      title : json['displayName'] ?? "",
      content : "",
      category : "");
}