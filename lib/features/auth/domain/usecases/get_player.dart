import '../entities/player.dart';
import '../../data/repositories/auth_repository.dart';

class GetPlayerUseCase {
  final AuthRepository repository;

  GetPlayerUseCase(this.repository);

  Future<Player?> call() async {
    final playerData = await repository.getPlayerData();
    
    if (playerData == null) return null;

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
