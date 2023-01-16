// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 1;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      uuid: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      category: fields[3] as String,
    )
      ..imageId = (fields[6] as List?)?.cast<String>()
      ..downloaded = fields[4] as bool
      ..saved = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(7)
      ..writeByte(6)
      ..write(obj.imageId)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.downloaded)
      ..writeByte(5)
      ..write(obj.saved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
