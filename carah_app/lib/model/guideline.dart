import 'package:carah_app/model/content.dart';
import 'package:carah_app/model/contentImage.dart';

class Guideline extends Content {
  int ?position;

  List<ContentImage> ?images;

  Guideline({required uuid, required title, required content, required category, required position}) : super(uuid: uuid, title: title, content: content, category: category);

  Guideline.fromJson(Map<String, dynamic> json)
      : position = json['fields']['position_in_guideline'] ?? "",
        images = (json['fields']['images'] as List?)?.map((item) =>
          ContentImage.fromJson(item)
        ).toList(),
        super(
          uuid: json['uuid'] ?? "",
          title: json['fields']['title'] ?? "",
          content: json['fields']['text'] ?? "",
          category: json['parent']['displayName'] ?? "",
        );
}