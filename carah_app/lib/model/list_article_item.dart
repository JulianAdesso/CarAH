import 'package:hive_flutter/hive_flutter.dart';

part 'list_article_item.g.dart';

@HiveType(typeId: 2)
class ListArticlesItem {
  @HiveField(0)
  String articleId;
  @HiveField(1)
  String title;
  @HiveField(2)
  bool saved;
  @HiveField(3)
  bool downloaded;

  ListArticlesItem({required this.articleId, required this.title, this.saved = false, this.downloaded = false});

  ListArticlesItem.fromJson(Map<String, dynamic> json)
      : articleId = json['uuid'],
        title = json['fields']['Display_Name'],
        saved = false,
        downloaded = false;
}
