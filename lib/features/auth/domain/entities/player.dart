import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String name;
  final String avatar;
  final String language;
  final DateTime createdAt;
  final bool isFirstLaunch;
  final int level;
  final int gold;
  final int gems;
  final int experience;

  const Player({
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

  Player copyWith({
    String? name,
    String? avatar,
    String? language,
    DateTime? createdAt,
    bool? isFirstLaunch,
    int? level,
    int? gold,
    int? gems,
    int? experience,
  }) {
    return Player(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      level: level ?? this.level,
      gold: gold ?? this.gold,
      gems: gems ?? this.gems,
      experience: experience ?? this.experience,
    );
  }

  @override
  List<Object?> get props => [
        name,
        avatar,
        language,
        createdAt,
        isFirstLaunch,
        level,
        gold,
        gems,
        experience,
      ];
}
