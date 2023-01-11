
import 'package:hive_flutter/hive_flutter.dart';

part 'list_faq_item.g.dart';

@HiveType(typeId: 5)
class ListFAQItem {
  @HiveField(0)
  String questionId;
  @HiveField(1)
  String title;
  @HiveField(2)
  bool saved;
  @HiveField(3)
  bool downloaded;

  ListFAQItem({required this.questionId, required this.title, this.saved = false, this.downloaded = false});

  ListFAQItem.fromJson(Map<String, dynamic> json)
      : questionId = json['uuid'],
        title = json['fields']['Display_Name'] ?? "",
        saved = false,
        downloaded = false;
}
