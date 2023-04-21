import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';

part 'content_image.g.dart';

@HiveType(typeId: 3)
class ContentImage extends HiveObject {
  @HiveField(0)
  String uuid;
  @HiveField(1)
  String displayName;
  @HiveField(2)
  Uint8List? image;

  ContentImage(
      {required this.uuid, required this.displayName, required this.image});

  ContentImage.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        displayName = json['displayName'];
}
