// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListItemAdapter extends TypeAdapter<ListItem> {
  @override
  final int typeId = 6;

  @override
  ListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListItem(
      uuid: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String?,
      icon: fields[3] as String?,
      routerLink: fields[4] as String?,
      availableInOfflineMode: fields[5] as bool,
      isDisabled: fields[6] as bool,
      position: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ListItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.routerLink)
      ..writeByte(5)
      ..write(obj.availableInOfflineMode)
      ..writeByte(6)
      ..write(obj.isDisabled)
      ..writeByte(7)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
