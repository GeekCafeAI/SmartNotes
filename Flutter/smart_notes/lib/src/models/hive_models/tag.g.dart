// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTagAdapter extends TypeAdapter<HiveTag> {
  @override
  final int typeId = 1;

  @override
  HiveTag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTag(
      name: fields[0] as String,
      isEnabled: fields[1] as bool,
      isFavourite: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTag obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isEnabled)
      ..writeByte(2)
      ..write(obj.isFavourite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
