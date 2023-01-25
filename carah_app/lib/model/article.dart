import 'package:hive_flutter/hive_flutter.dart';

import 'content.dart';


part 'article.g.dart';

@HiveType(typeId: 1)
class Article extends Content{

  @HiveField(6)
  List<String> ?imageId;

  Article({required String uuid, required String title, required String content, required String category}) : super(uuid: uuid, title: title, content: content, category: category);

  Article.fromJson(Map<String, dynamic> json)
      : imageId = (json['fields']['images'] as List?)?.map((item) => item.toString()).toList(), super(uuid : json['uuid'] ?? "",
        title : json['fields']['Display_Name'] ?? "",
        content : json['fields']['Html_Text'] ?? "",
        category : json['parentNode']['uuid'] ?? "");
}