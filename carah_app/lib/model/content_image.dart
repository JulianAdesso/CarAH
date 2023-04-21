import 'dart:typed_data';

class ContentImage {
  String uuid;
  String displayName;
  Uint8List? image;

  ContentImage(
      {required this.uuid, required this.displayName, required this.image});

  ContentImage.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        displayName = json['displayName'];
}
