// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContentImageAdapter extends TypeAdapter<ContentImage> {
  @override
  final int typeId = 3;

  @override
  ContentImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentImage(
      uuid: fields[0] as String,
      displayName: fields[1] as String,
      image: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, ContentImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
