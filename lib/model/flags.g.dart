// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flags.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlagsAdapter extends TypeAdapter<Flags> {
  @override
  Flags read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flags(
      name: fields[0] as String,
      value: fields[1] as bool,
      data: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Flags obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get typeId => 3;
}
