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
  
  @HiveField(5)
  int level;
  
  @HiveField(6)
  int gold;
  
  @HiveField(7)
  int gems;
  
  @HiveField(8)
  int experience;

  PlayerData({
    required this.name,
    required this.avatar,
    required this.language,
    required this.createdAt,
    this.isFirstLaunch = true,
    this.level = 1,
    this.gold = 0,
    this.gems = 0,
    this.experience = 0,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'avatar': avatar,
    'language': language,
    'createdAt': createdAt.toIso8601String(),
    'isFirstLaunch': isFirstLaunch,
    'level': level,
    'gold': gold,
    'gems': gems,
    'experience': experience,
  };
  
  factory PlayerData.fromJson(Map<String, dynamic> json) => PlayerData(
    name: json['name'],
    avatar: json['avatar'],
    language: json['language'],
    createdAt: DateTime.parse(json['createdAt']),
    isFirstLaunch: json['isFirstLaunch'] ?? true,
    level: json['level'] ?? 1,
    gold: json['gold'] ?? 0,
    gems: json['gems'] ?? 0,
    experience: json['experience'] ?? 0,
  );
}
