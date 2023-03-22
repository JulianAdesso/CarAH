import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ContentImage{
  String uuid;
  String displayName;
  Image? image;

  ContentImage({required this.uuid, required this.displayName, required Uint8List imageBytes}):
   image = Image.memory(imageBytes);

  ContentImage.fromJson(Map<String, dynamic> json):
  uuid = json['uuid'],
  displayName = json['displayName'];

}