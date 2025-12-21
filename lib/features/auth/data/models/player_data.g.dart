// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData(
      name: fields[0] as String,
      avatar: fields[1] as String,
      language: fields[2] as String,
      createdAt: fields[3] as DateTime,
      isFirstLaunch: fields[4] as bool,
      level: fields[5] as int,
      gold: fields[6] as int,
      gems: fields[7] as int,
      experience: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.avatar)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isFirstLaunch)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.gold)
      ..writeByte(7)
      ..write(obj.gems)
      ..writeByte(8)
      ..write(obj.experience);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
