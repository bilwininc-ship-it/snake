import '../entities/player.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/player_data.dart';

class CreatePlayerUseCase {
  final AuthRepository repository;

  CreatePlayerUseCase(this.repository);

  Future<Player> call({
    required String name,
    required String avatar,
    required String language,
  }) async {
    final playerData = PlayerData(
      name: name,
      avatar: avatar,
      language: language,
      createdAt: DateTime.now(),
      isFirstLaunch: false,
      level: 1,
      gold: 100,
      gems: 10,
      experience: 0,
    );

    await repository.savePlayerData(playerData);

    return Player(
      name: playerData.name,
      avatar: playerData.avatar,
      language: playerData.language,
      createdAt: playerData.createdAt,
      isFirstLaunch: playerData.isFirstLaunch,
      level: playerData.level,
      gold: playerData.gold,
      gems: playerData.gems,
      experience: playerData.experience,
    );
  }
}
