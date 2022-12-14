// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 4;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      uuid: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      category: fields[3] as String,
    )
      ..downloaded = fields[4] as bool
      ..saved = fields[5] as bool
      ..imageId = (fields[6] as List?)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.saved)
      ..writeByte(6)
      ..write(obj.imageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
