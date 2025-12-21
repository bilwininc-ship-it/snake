import 'package:hive/hive.dart';

part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends HiveObject {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String avatar;
  
  @HiveField(2)
  String language;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  bool isFirstLaunch;

  PlayerData({
    required this.name,
    required this.avatar,
    required this.language,
    required this.createdAt,
    this.isFirstLaunch = true,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'avatar': avatar,
    'language': language,
    'createdAt': createdAt.toIso8601String(),
    'isFirstLaunch': isFirstLaunch,
  };
  
  factory PlayerData.fromJson(Map<String, dynamic> json) => PlayerData(
    name: json['name'],
    avatar: json['avatar'],
    language: json['language'],
    createdAt: DateTime.parse(json['createdAt']),
    isFirstLaunch: json['isFirstLaunch'] ?? true,
  );
}
