// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_faq_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListFAQItemAdapter extends TypeAdapter<ListFAQItem> {
  @override
  final int typeId = 5;

  @override
  ListFAQItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListFAQItem(
      questionId: fields[0] as String,
      title: fields[1] as String,
      saved: fields[2] as bool,
      downloaded: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ListFAQItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.questionId)
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
      other is ListFAQItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
