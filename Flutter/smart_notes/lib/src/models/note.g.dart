// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveNoteAdapter extends TypeAdapter<HiveNote> {
  @override
  final int typeId = 0;

  @override
  HiveNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveNote(
      id: fields[0] as int,
      userId: fields[1] as String,
      status: fields[2] as String,
      text: fields[3] as String,
      tags: fields[4] as String,
      createdAt: fields[5] as String,
      updatedAt: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveNote obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
