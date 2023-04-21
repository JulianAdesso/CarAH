import 'package:carah_app/model/content_image.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'content.dart';


part 'article.g.dart';

@HiveType(typeId: 1)
class Article extends Content{

  @HiveField(6)
  List<ContentImage> ?images;

  Article({required String uuid, required String title, required String content, required String category}) : super(uuid: uuid, title: title, content: content, category: category);

  Article.fromJson(Map<String, dynamic> json)
      : images = (json['fields']['images'] as List?) ?.map((item) => ContentImage.fromJson(item)).toList(),
        super(
        uuid: json['uuid'] ?? "",
        title: json['fields']['title'] ?? "",
        content: json['fields']['text'] ?? "",
        category: json['parent']['displayName'] ?? "",
      );
}