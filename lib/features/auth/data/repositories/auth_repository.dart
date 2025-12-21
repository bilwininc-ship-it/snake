import 'package:hive_flutter/hive_flutter.dart';
import 'package:snake_empires/core/constants/app_constants.dart';
import 'package:snake_empires/features/auth/data/models/player_data.dart';

class AuthRepository {
  late Box<PlayerData> _playerBox;
  
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PlayerDataAdapter());
    }
    
    _playerBox = await Hive.openBox<PlayerData>(AppConstants.hiveBoxPlayer);
  }
  
  Future<PlayerData?> getPlayerData() async {
    if (_playerBox.isEmpty) return null;
    return _playerBox.get(AppConstants.keyPlayerData);
  }
  
  Future<void> savePlayerData(PlayerData playerData) async {
    await _playerBox.put(AppConstants.keyPlayerData, playerData);
  }
  
  Future<bool> isFirstLaunch() async {
    final playerData = await getPlayerData();
    return playerData?.isFirstLaunch ?? true;
  }
  
  Future<void> setFirstLaunchComplete() async {
    final playerData = await getPlayerData();
    if (playerData != null) {
      playerData.isFirstLaunch = false;
      await savePlayerData(playerData);
    }
  }
  
  Future<void> clearData() async {
    await _playerBox.clear();
  }
}
