// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_article_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListArticlesItemAdapter extends TypeAdapter<ListArticlesItem> {
  @override
  final int typeId = 2;

  @override
  ListArticlesItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListArticlesItem(
      articleId: fields[0] as String,
      title: fields[1] as String,
      saved: fields[2] as bool,
      downloaded: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ListArticlesItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.articleId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.saved)
      ..writeByte(3)
      ..write(obj.downloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListArticlesItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
