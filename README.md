# 🐍 Snake Empires - Profesyonel Mobil Oyun Projesi

## 📋 İçindekiler
- [Proje Hakkında](#proje-hakkında)
- [Teknik Özellikler](#teknik-özellikler)
- [Güvenlik ve Anti-Hack Sistemi](#güvenlik-ve-anti-hack-sistemi)
- [Mimari Yapı](#mimari-yapı)
- [Kurulum](#kurulum)
- [Çok Dilli Destek](#çok-dilli-destek)
- [Oyun Mekanikleri](#oyun-mekanikleri)
- [Monetizasyon](#monetizasyon)
- [Geliştirme Yol Haritası](#geliştirme-yol-haritası)

---

## 🎮 Proje Hakkında

**Snake Empires**, modern mobil oyun standartlarına uygun olarak geliştirilmiş, hibrit türde (Snake Action + City Building RPG) profesyonel bir mobil oyundur.

### Temel Özellikler
- ✅ **2 Elle Oynanabilir**: Dual Joystick kontrol sistemi
- ✅ **Yatay Oynanış**: Sadece Landscape (Yatay) modda oynanır
- ✅ **Modüler Yılan Sistemi**: Kafa, Gövde, Kuyruk parçaları ayrı ayrı geliştirilebilir
- ✅ **Geniş Haritalar**: Tiled Map Engine ile oluşturulmuş keşfedilebilir dünyalar
- ✅ **RPG Elementleri**: Loot toplama, karakter geliştirme, envanter sistemi
- ✅ **Şehir Kurma**: Yılan kolonisi inşa etme ve yönetme
- ✅ **Offline Öncelikli**: İnternet olmadan oynanabilir
- ✅ **Çok Dilli**: Global oyuncu kitlesine hitap eden dil desteği
- ✅ **Güvenli**: Anti-cheat ve şifreleme sistemleri

### Desteklenen Platformlar
- 📱 **Android**: Minimum API 21 (Android 5.0+)
- 🍎 **iOS**: Minimum iOS 12.0+
- 🪟 **Windows**: Test ve geliştirme amaçlı

---

## 🔧 Teknik Özellikler

### Flutter & Dart
- **Flutter SDK**: ^3.24.0
- **Dart**: ^3.5.0
- **Flame Engine**: ^1.18.0 (2D Oyun Motoru)

### Kullanılan Ana Paketler

#### Oyun Motoru
```yaml
flame: ^1.18.0                 # 2D game engine
flame_tiled: ^1.19.0           # Tiled map support
flame_audio: ^2.1.7            # Ses sistemi
```

#### State Management
```yaml
flutter_bloc: ^8.1.6           # Business Logic Component
equatable: ^2.0.5              # Value comparison
```

#### Veri Yönetimi (Offline Storage)
```yaml
hive: ^2.2.3                   # NoSQL veritabanı
hive_flutter: ^1.1.0           # Hive Flutter entegrasyonu
path_provider: ^2.1.4          # Dosya yolu yönetimi
shared_preferences: ^2.3.2     # Basit key-value storage
```

#### Firebase Entegrasyonu
```yaml
firebase_core: ^3.6.0          # Firebase temel
firebase_analytics: ^11.3.3    # Analitik
firebase_crashlytics: ^4.1.3   # Crash raporlama
```

#### Monetizasyon
```yaml
google_mobile_ads: ^5.2.0      # AdMob reklamlar
in_app_purchase: ^3.2.0        # Uygulama içi satın alma
```

#### Çok Dilli Destek
```yaml
intl: ^0.19.0                  # Uluslararasılaştırma
easy_localization: ^3.0.7      # Kolay çeviri yönetimi
```

#### Dependency Injection
```yaml
get_it: ^8.0.0                 # Service locator pattern
```

#### Güvenlik
```yaml
encrypt: ^5.0.3                # Veri şifreleme
crypto: ^3.0.5                 # Kriptografik işlemler
flutter_secure_storage: ^9.2.2 # Güvenli storage
```

---

## 🔒 Güvenlik ve Anti-Hack Sistemi

### 1. Veri Güvenliği

#### Şifreleme Katmanları
```dart
// Kritik veriler şifrelenir (puan, altın, elmas)
class SecureStorage {
  final encrypter = Encrypter(AES(Key.fromSecureRandom(32)));
  
  String encryptData(String data) {
    final iv = IV.fromSecureRandom(16);
    return encrypter.encrypt(data, iv: iv).base64;
  }
  
  String decryptData(String encrypted) {
    return encrypter.decrypt64(encrypted, iv: iv);
  }
}
```

#### Hassas Verilerin Korunması
- ✅ Para birimi (Altın, Elmas) şifreli saklanır
- ✅ Oyuncu puanları hash ile doğrulanır
- ✅ Kritik save dosyaları imzalanır
- ✅ Memory'de plain text olarak tutulmaz

### 2. Anti-Cheat Mekanizmaları

#### Değer Doğrulama
```dart
class AntiCheat {
  // Server-side validation için checksum
  String generateChecksum(PlayerData data) {
    final content = '${data.gold}|${data.gems}|${data.level}|$SECRET_KEY';
    return sha256.convert(utf8.encode(content)).toString();
  }
  
  bool validateChecksum(PlayerData data, String checksum) {
    return generateChecksum(data) == checksum;
  }
}
```

#### Bellek Koruma
- ✅ Memory editor'lere karşı koruma
- ✅ Root/Jailbreak detection
- ✅ Hız hilelerine karşı timestamp kontrolü
- ✅ Oyun içi değerlerin periyodik validasyonu

### 3. Network Güvenliği

#### API İstekleri
```dart
class SecureAPI {
  Future<Response> makeSecureRequest(String endpoint, Map data) async {
    // Request imzalama
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final signature = generateSignature(data, timestamp);
    
    return await http.post(
      Uri.parse(endpoint),
      headers: {
        'X-Timestamp': timestamp.toString(),
        'X-Signature': signature,
        'X-App-Version': APP_VERSION,
      },
      body: jsonEncode(data),
    );
  }
}
```

#### SSL Pinning
```dart
// Certificate pinning ile MITM saldırılarını engelle
class SecureHttpClient {
  static HttpClient createClient() {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) {
      return cert.sha1.toString() == EXPECTED_CERT_SHA1;
    };
    return client;
  }
}
```

### 4. Save File Güvenliği

```dart
class SecureSaveSystem {
  Future<void> saveGame(GameData data) async {
    // 1. Serialize
    final json = jsonEncode(data.toJson());
    
    // 2. Encrypt
    final encrypted = encryptData(json);
    
    // 3. Generate signature
    final signature = generateSignature(encrypted);
    
    // 4. Save with metadata
    final saveFile = SaveFile(
      data: encrypted,
      signature: signature,
      timestamp: DateTime.now(),
      version: SAVE_VERSION,
    );
    
    await Hive.box('game_data').put('save', saveFile.toJson());
  }
  
  Future<GameData?> loadGame() async {
    final saveFile = await Hive.box('game_data').get('save');
    
    // Signature doğrulama
    if (!validateSignature(saveFile.data, saveFile.signature)) {
      throw SecurityException('Save file tampered!');
    }
    
    // Decrypt ve deserialize
    final json = decryptData(saveFile.data);
    return GameData.fromJson(jsonDecode(json));
  }
}
```

### 5. Oyun İçi Doğrulama

#### Fizik ve Hareket Kontrolü
```dart
class MovementValidator {
  Vector2 lastPosition;
  DateTime lastUpdate;
  
  bool validateMovement(Vector2 newPosition, double deltaTime) {
    final distance = (newPosition - lastPosition).length;
    final maxPossibleDistance = MAX_SPEED * deltaTime * 1.2; // %20 tolerans
    
    if (distance > maxPossibleDistance) {
      _reportCheat('Impossible movement detected');
      return false;
    }
    
    lastPosition = newPosition;
    lastUpdate = DateTime.now();
    return true;
  }
}
```

#### Kaynak Toplama Limitleri
```dart
class ResourceValidator {
  Map<String, DateTime> lastCollectionTime = {};
  
  bool canCollectResource(String resourceId) {
    final lastTime = lastCollectionTime[resourceId];
    if (lastTime == null) return true;
    
    final elapsed = DateTime.now().difference(lastTime);
    return elapsed.inSeconds >= MIN_COLLECTION_INTERVAL;
  }
}
```

### 6. Root/Jailbreak Detection

```dart
class DeviceSecurityCheck {
  Future<bool> isDeviceSecure() async {
    // Android root check
    if (Platform.isAndroid) {
      final rootFiles = [
        '/system/app/Superuser.apk',
        '/sbin/su',
        '/system/bin/su',
        '/system/xbin/su',
      ];
      
      for (final file in rootFiles) {
        if (await File(file).exists()) return false;
      }
    }
    
    // iOS jailbreak check
    if (Platform.isIOS) {
      final jailbreakFiles = [
        '/Applications/Cydia.app',
        '/Library/MobileSubstrate/MobileSubstrate.dylib',
        '/bin/bash',
        '/usr/sbin/sshd',
      ];
      
      for (final file in jailbreakFiles) {
        if (await File(file).exists()) return false;
      }
    }
    
    return true;
  }
}
```

### 7. Obfuscation (Kod Karartma)

```yaml
# flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
# Kod okunabilirliğini zorlaştırır
```

---

## 🏗️ Mimari Yapı

### Clean Architecture Katmanları

```
lib/
├── core/                          # Temel altyapı
│   ├── constants/                 # Sabitler
│   │   └── app_constants.dart
│   ├── errors/                    # Hata yönetimi
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── utils/                     # Yardımcı fonksiyonlar
│   │   ├── validators.dart
│   │   └── formatters.dart
│   ├── network/                   # API client
│   │   └── api_client.dart
│   └── services/                  # Global servisler
│       ├── injection_container.dart
│       ├── secure_storage_service.dart
│       └── analytics_service.dart
│
├── features/                      # Özellik bazlı modüller
│   ├── snake_game/                # Ana oyun mekaniği
│   │   ├── data/
│   │   │   ├── models/           # Data modelleri
│   │   │   ├── repositories/     # Repository implementasyonu
│   │   │   └── datasources/      # Veri kaynakları (local/remote)
│   │   ├── domain/
│   │   │   ├── entities/         # İş mantığı nesneleri
│   │   │   ├── repositories/     # Repository interface
│   │   │   └── usecases/         # İş mantığı
│   │   └── presentation/
│   │       ├── game/             # Flame game component
│   │       ├── components/       # UI components
│   │       └── bloc/             # State management
│   │
│   ├── city_building/             # Şehir kurma sistemi
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── rpg_system/                # RPG mekanikleri
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── monetization/              # Reklam & IAP
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/                        # Ortak kaynaklar
│   ├── widgets/                  # Reusable widgets
│   ├── theme/                    # Tema tanımları
│   └── extensions/               # Extension methods
│
└── l10n/                         # Çok dilli destek
    ├── intl_en.arb              # İngilizce
    ├── intl_tr.arb              # Türkçe
    ├── intl_ar.arb              # Arapça
    ├── intl_zh.arb              # Çince
    ├── intl_de.arb              # Almanca
    ├── intl_es.arb              # İspanyolca
    ├── intl_fr.arb              # Fransızca
    ├── intl_ru.arb              # Rusça
    ├── intl_ja.arb              # Japonca
    └── intl_pt.arb              # Portekizce
```

### Veri Akışı (Data Flow)

```
UI Layer (Presentation)
    ↓
BLoC (Business Logic Component)
    ↓
UseCase (Domain Layer)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (Local/Remote)
    ↓
Hive / Firebase / API
```

---

## 🚀 Kurulum

### Ön Gereksinimler
- Flutter SDK 3.24.0+
- Dart 3.5.0+
- Android Studio / Xcode
- Git

### Adım 1: Projeyi Klonlama
```bash
git clone https://github.com/your-username/snake-empires.git
cd snake-empires
```

### Adım 2: Bağımlılıkları Yükleme
```bash
flutter pub get
```

### Adım 3: Firebase Kurulumu (Opsiyonel)
```bash
# Firebase CLI kurulumu
npm install -g firebase-tools

# Firebase projesine bağlanma
flutterfire configure
```

### Adım 4: Kod Üretimi
```bash
# Hive adapter'ları ve JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs
```

### Adım 5: Çalıştırma
```bash
# Debug mode
flutter run

# Release mode (Android)
flutter build apk --release --obfuscate --split-debug-info=build/symbols

# Release mode (iOS)
flutter build ios --release --obfuscate --split-debug-info=build/symbols
```

---

## 🌍 Çok Dilli Destek

### Desteklenen Diller

| Dil | Kod | Dosya | Durum |
|-----|-----|-------|-------|
| 🇬🇧 İngilizce | en | intl_en.arb | ✅ Varsayılan |
| 🇹🇷 Türkçe | tr | intl_tr.arb | ✅ Tamamlandı |
| 🇸🇦 Arapça | ar | intl_ar.arb | ✅ RTL Destekli |
| 🇨🇳 Çince (Basit) | zh | intl_zh.arb | ✅ Tamamlandı |
| 🇩🇪 Almanca | de | intl_de.arb | ✅ Tamamlandı |
| 🇪🇸 İspanyolca | es | intl_es.arb | ✅ Tamamlandı |
| 🇫🇷 Fransızca | fr | intl_fr.arb | ✅ Tamamlandı |
| 🇷🇺 Rusça | ru | intl_ru.arb | ✅ Tamamlandı |
| 🇯🇵 Japonca | ja | intl_ja.arb | ✅ Tamamlandı |
| 🇧🇷 Portekizce | pt | intl_pt.arb | ✅ Tamamlandı |

### Dil Sistemi Kullanımı

#### main.dart Yapılandırması
```dart
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), // İngilizce
        Locale('tr'), // Türkçe
        Locale('ar'), // Arapça
        Locale('zh'), // Çince
        Locale('de'), // Almanca
        Locale('es'), // İspanyolca
        Locale('fr'), // Fransızca
        Locale('ru'), // Rusça
        Locale('ja'), // Japonca
        Locale('pt'), // Portekizce
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const SnakeEmpiresApp(),
    ),
  );
}
```

#### Çeviri Dosyası Örneği (intl_en.arb)
```json
{
  "app_name": "Snake Empires",
  "main_menu_new_game": "NEW GAME",
  "main_menu_continue": "CONTINUE",
  "main_menu_city": "CITY",
  "main_menu_settings": "SETTINGS",
  "game_hud_health": "HP",
  "game_hud_score": "Score",
  "game_hud_level": "Level",
  "city_building_food": "Food",
  "city_building_gold": "Gold",
  "city_building_gems": "Gems",
  "rpg_upgrade_head": "Upgrade Head",
  "rpg_upgrade_body": "Upgrade Body",
  "rpg_upgrade_tail": "Upgrade Tail",
  "settings_language": "Language",
  "settings_sound": "Sound",
  "settings_music": "Music",
  "dialog_confirm": "Confirm",
  "dialog_cancel": "Cancel"
}
```

#### Çeviri Dosyası Örneği (intl_tr.arb)
```json
{
  "app_name": "Yılan İmparatorlukları",
  "main_menu_new_game": "YENİ OYUN",
  "main_menu_continue": "DEVAM ET",
  "main_menu_city": "ŞEHİR",
  "main_menu_settings": "AYARLAR",
  "game_hud_health": "CAN",
  "game_hud_score": "Skor",
  "game_hud_level": "Seviye",
  "city_building_food": "Yemek",
  "city_building_gold": "Altın",
  "city_building_gems": "Elmas",
  "rpg_upgrade_head": "Kafayı Geliştir",
  "rpg_upgrade_body": "Gövdeyi Geliştir",
  "rpg_upgrade_tail": "Kuyruğu Geliştir",
  "settings_language": "Dil",
  "settings_sound": "Ses",
  "settings_music": "Müzik",
  "dialog_confirm": "Onayla",
  "dialog_cancel": "İptal"
}
```

#### RTL (Right-to-Left) Desteği - Arapça
```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' 
          ? TextDirection.rtl 
          : TextDirection.ltr,
      child: YourWidget(),
    );
  }
}
```

#### Kod İçinde Kullanım
```dart
// Basit çeviri
Text('main_menu_new_game'.tr())

// Parametreli çeviri
Text('welcome_message'.tr(args: ['Player Name']))

// Çoğul formlar
Text('items_count'.plural(itemCount))

// Dil değiştirme
ElevatedButton(
  onPressed: () {
    context.setLocale(Locale('tr'));
  },
  child: Text('Türkçe'),
)
```

### Dil Seçimi UI

```dart
class LanguageSelectionScreen extends StatelessWidget {
  final languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇬🇧'},
    {'name': 'Türkçe', 'code': 'tr', 'flag': '🇹🇷'},
    {'name': 'العربية', 'code': 'ar', 'flag': '🇸🇦'},
    {'name': '中文', 'code': 'zh', 'flag': '🇨🇳'},
    {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
    {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'Русский', 'code': 'ru', 'flag': '🇷🇺'},
    {'name': '日本語', 'code': 'ja', 'flag': '🇯🇵'},
    {'name': 'Português', 'code': 'pt', 'flag': '🇧🇷'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final lang = languages[index];
        final isSelected = context.locale.languageCode == lang['code'];
        
        return ListTile(
          leading: Text(lang['flag']!, style: TextStyle(fontSize: 32)),
          title: Text(lang['name']!),
          trailing: isSelected ? Icon(Icons.check, color: Colors.amber) : null,
          onTap: () {
            context.setLocale(Locale(lang['code']!));
          },
        );
      },
    );
  }
}
```

---

## 🎮 Oyun Mekanikleri

### 1. Yılan Kontrolü (Dual Joystick)

#### Sol Joystick - Hareket
- 360° serbest hareket
- Analog hassasiyet
- Hız kontrolü (joystick mesafesine göre)

#### Sağ Joystick - Saldırı/Beceri
- Saldırı yönü belirleme
- Özel yetenekleri tetikleme
- Etkileşim (NPC, obje)

```dart
class SnakeController {
  Vector2 movementInput = Vector2.zero();
  Vector2 attackInput = Vector2.zero();
  
  void updateMovement(JoystickComponent leftStick) {
    movementInput = leftStick.relativeDelta;
    snake.velocity = movementInput * snake.speed;
  }
  
  void updateAttack(JoystickComponent rightStick) {
    if (!rightStick.delta.isZero()) {
      attackInput = rightStick.relativeDelta.normalized();
      snake.performAttack(attackInput);
    }
  }
}
```

### 2. Modüler Yılan Sistemi

#### Parça Tipleri
```dart
enum SnakePartType {
  head,      // Kafa - Saldırı gücü
  body,      // Gövde - Savunma
  tail,      // Kuyruk - Hız
}

class SnakePart {
  SnakePartType type;
  int level;
  Map<String, double> stats;
  String visualId;
  List<Ability> abilities;
  
  // Her parça ayrı geliştirilebilir
  void upgrade() {
    level++;
    stats['power'] *= 1.1;
    // Yeni yetenekler unlock
    if (level % 5 == 0) {
      unlockNewAbility();
    }
  }
}
```

#### Yılan Büyütme
```dart
class SnakeGrowthSystem {
  void addSegment(SnakePartType type, int level) {
    final newPart = SnakePart(
      type: type,
      level: level,
      position: calculateNewPosition(),
    );
    
    snake.segments.add(newPart);
    snake.updateStats();
  }
  
  void updateStats() {
    // Tüm parçaların statları toplanır
    snake.totalAttack = segments
        .where((s) => s.type == SnakePartType.head)
        .map((s) => s.stats['attack'])
        .fold(0, (a, b) => a + b);
        
    snake.totalDefense = segments
        .where((s) => s.type == SnakePartType.body)
        .map((s) => s.stats['defense'])
        .fold(0, (a, b) => a + b);
  }
}
```

### 3. Loot Sistemi

```dart
class LootSystem {
  final Random random = Random();
  
  LootDrop generateLoot(EnemyType enemy, int playerLevel) {
    final dropTable = LootTables.getDropTable(enemy);
    final rolledItems = <LootItem>[];
    
    for (final entry in dropTable) {
      if (random.nextDouble() < entry.dropChance) {
        final item = LootItem(
          id: entry.itemId,
          rarity: rollRarity(),
          quantity: rollQuantity(entry),
        );
        rolledItems.add(item);
      }
    }
    
    return LootDrop(items: rolledItems);
  }
  
  Rarity rollRarity() {
    final roll = random.nextDouble();
    if (roll < 0.01) return Rarity.legendary;  // %1
    if (roll < 0.05) return Rarity.epic;       // %4
    if (roll < 0.15) return Rarity.rare;       // %10
    if (roll < 0.35) return Rarity.uncommon;   // %20
    return Rarity.common;                      // %65
  }
}
```

### 4. Harita ve Keşif

#### Tiled Map Entegrasyonu
```dart
class MapManager {
  late TiledComponent currentMap;
  
  Future<void> loadMap(String mapName) async {
    currentMap = await TiledComponent.load(
      mapName,
      Vector2.all(16), // Tile size
    );
    
    // Collision layer
    final collisionLayer = currentMap.tileMap.getLayer('collision');
    _setupCollisions(collisionLayer);
    
    // Spawn points
    final spawns = currentMap.tileMap.getLayer('spawns');
    _spawnEnemies(spawns);
    
    // Secret areas
    final secrets = currentMap.tileMap.getLayer('secrets');
    _setupSecretAreas(secrets);
  }
  
  void _setupCollisions(Layer layer) {
    for (final tile in layer.tiles) {
      if (tile.gid > 0) {
        final collider = RectangleHitbox(
          position: tile.position,
          size: Vector2.all(16),
        );
        world.add(collider);
      }
    }
  }
}
```

#### Yeraltı Tünelleri
```dart
class TunnelSystem {
  Map<String, TunnelEntrance> entrances = {};
  
  void createTunnel(Vector2 entrance, Vector2 exit) {
    final tunnelId = Uuid().v4();
    
    entrances[tunnelId] = TunnelEntrance(
      id: tunnelId,
      entrancePos: entrance,
      exitPos: exit,
      requiresKey: random.nextBool(),
    );
  }
  
  void enterTunnel(String tunnelId) {
    final tunnel = entrances[tunnelId];
    if (tunnel.requiresKey && !player.hasKey(tunnelId)) {
      showMessage('tunnel_locked'.tr());
      return;
    }
    
    // Fade out
    game.camera.viewfinder.add(
      OpacityEffect.fadeOut(EffectController(duration: 0.5)),
    );
    
    // Teleport
    Future.delayed(Duration(milliseconds: 500), () {
      player.position = tunnel.exitPos;
      game.camera.viewfinder.add(
        OpacityEffect.fadeIn(EffectController(duration: 0.5)),
      );
    });
  }
}
```

### 5. Şehir Kurma (City Building)

```dart
class CityBuildingSystem {
  List<Building> buildings = [];
  Resources resources = Resources();
  
  bool canBuild(BuildingType type) {
    final cost = BuildingCosts.getCost(type);
    return resources.hasEnough(cost);
  }
  
  Future<void> buildStructure(BuildingType type, Vector2 position) async {
    if (!canBuild(type)) {
      showMessage('insufficient_resources'.tr());
      return;
    }
    
    resources.spend(BuildingCosts.getCost(type));
    
    final building = Building(
      type: type,
      position: position,
      level: 1,
    );
    
    buildings.add(building);
    building.startConstruction();
  }
  
  void upgradeBuilding(Building building) {
    final upgradeCost = building.getUpgradeCost();
    if (resources.hasEnough(upgradeCost)) {
      resources.spend(upgradeCost);
      building.upgrade();
    }
  }
}

class Building {
  BuildingType type;
  int level;
  Vector2 position;
  double productionRate;
  
  void produceResources(double dt) {
    switch (type) {
      case BuildingType.farm:
        resources.food += productionRate * dt;
        break;
      case BuildingType.mine:
        resources.gold += productionRate * dt;
        break;
      case BuildingType.hatchery:
        if (canSpawnBaby()) spawnBabySnake();
        break;
    }
  }
}
```

---

## 💰 Monetizasyon

### 1. Reklam Sistemi (AdMob)

#### Rewarded Video (Ödüllü Video)
```dart
class RewardedAdManager {
  RewardedAd? _rewardedAd;
  
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AppConstants.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _setAdCallbacks();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed: $error');
        },
      ),
    );
  }
  
  void showRewardedAd(RewardType rewardType) {
    if (_rewardedAd == null) {
      showMessage('ad_not_ready'.tr());
      return;
    }
    
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        _giveReward(rewardType);
      },
    );
  }
  
  void _giveReward(RewardType type) {
    switch (type) {
      case RewardType.revive:
        player.revive();
        break;
      case RewardType.doubleCoins:
        player.applyMultiplier(2.0, duration: Duration(minutes: 5));
        break;
      case RewardType.freeGems:
        player.addGems(10);
        break;
    }
  }
}
```

#### Interstitial Ads (Seviye Arası)
```dart
class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  int _levelCompleteCount = 0;
  
  void showInterstitial() {
    _levelCompleteCount++;
    
    // Her 3 seviyede bir göster
    if (_levelCompleteCount % 3 == 0 && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd();
    }
  }
}
```

### 2. In-App Purchase (IAP)

```dart
class IAPManager {
  final InAppPurchase _iap = InAppPurchase.instance;
  
  // Ürün ID'leri
  static const String removeAds = 'remove_ads';
  static const String starterPack = 'starter_pack';
  static const String gems_100 = 'gems_100';
  static const String gems_500 = 'gems_500';
  static const String gems_1000 = 'gems_1000';
  static const String vipPass = 'vip_pass_monthly';
  
  Future<void> buyProduct(String productId) async {
    final available = await _iap.isAvailable();
    if (!available) return;
    
    final purchaseParam = PurchaseParam(
      productDetails: await _getProductDetails(productId),
    );
    
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }
  
  void _handlePurchase(PurchaseDetails purchase) {
    if (purchase.status == PurchaseStatus.purchased) {
      _deliverProduct(purchase.productID);
      _iap.completePurchase(purchase);
    }
  }
  
  void _deliverProduct(String productId) {
    switch (productId) {
      case removeAds:
        adsRemoved = true;
        saveToSecureStorage('ads_removed', 'true');
        break;
      case gems_100:
        player.addGems(100);
        break;
      case vipPass:
        player.activateVIP(Duration(days: 30));
        break;
    }
  }
}
```

### 3. Monetizasyon Stratejisi

#### Dengeli Yaklaşım
- ✅ **Ödüllü Videolar**: Oyuncuya değer katar (canlanma, bonus)
- ✅ **IAP**: Opsiyonel, oyunu hızlandırır ama P2W değil
- ✅ **VIP Pass**: Küçük avantajlar (reklamsız, %10 bonus)
- ❌ **Agresif reklamlar**: Oyun deneyimini bozmaz

#### Fiyatlandırma
```dart
class PricingTiers {
  static const prices = {
    'starter_pack': '\$2.99',      // Başlangıç paketi
    'gems_100': '\$0.99',          // Küçük elmas paketi
    'gems_500': '\$3.99',          // Orta elmas paketi
    'gems_1000': '\$6.99',         // Büyük elmas paketi
    'remove_ads': '\$4.99',        // Reklamları kaldır
    'vip_pass_monthly': '\$9.99',  // Aylık VIP
  };
}
```

---

## 🗺️ Geliştirme Yol Haritası

### ✅ Faz 1: Temel Altyapı (Tamamlandı)
- [x] Flutter proje kurulumu
- [x] Clean Architecture implementasyonu
- [x] Klasör yapısı oluşturma
- [x] Flame Engine entegrasyonu
- [x] Dual Joystick kontrol sistemi
- [x] Temel yılan hareketi

### 🔄 Faz 2: Core Gameplay (Devam Ediyor)
- [ ] Tiled harita entegrasyonu
- [ ] Çarpışma sistemi
- [ ] Düşman AI
- [ ] Loot sistemi
- [ ] Envanter yönetimi
- [ ] Save/Load sistemi

### 📋 Faz 3: RPG Sistemi
- [ ] Karakter geliştirme ağacı
- [ ] Yetenek sistemi
- [ ] Ekipman sistemi
- [ ] Stat hesaplama
- [ ] Quest sistemi

### 🏰 Faz 4: City Building
- [ ] Bina sistemi
- [ ] Kaynak üretimi
- [ ] Yavru yılan sistemi
- [ ] Şehir yönetimi UI
- [ ] Otomatik üretim

### 🎨 Faz 5: Polish & Content
- [ ] Profesyonel grafikler
- [ ] Ses efektleri & müzik
- [ ] Parçacık efektleri
- [ ] Animasyonlar
- [ ] 20+ harita
- [ ] 50+ düşman tipi

### 💰 Faz 6: Monetizasyon
- [ ] AdMob entegrasyonu
- [ ] IAP sistemi
- [ ] Daily rewards
- [ ] Battle pass
- [ ] Seasonal events

### 🌐 Faz 7: Online Features
- [ ] Firebase entegrasyonu
- [ ] Cloud save
- [ ] Leaderboard
- [ ] Achievements
- [ ] Friend system

### 🚀 Faz 8: Launch
- [ ] Beta testing
- [ ] Bug fixing
- [ ] Performance optimization
- [ ] Play Store / App Store yayını
- [ ] Marketing campaign

---

## 🛠️ Geliştirici Notları

### Performans Optimizasyonu

#### Object Pooling
```dart
class ObjectPool<T> {
  final List<T> _available = [];
  final List<T> _inUse = [];
  final T Function() _creator;
  
  T acquire() {
    if (_available.isEmpty) {
      return _creator();
    }
    final obj = _available.removeLast();
    _inUse.add(obj);
    return obj;
  }
  
  void release(T obj) {
    _inUse.remove(obj);
    _available.add(obj);
  }
}

// Kullanım
final bulletPool = ObjectPool<Bullet>(() => Bullet());
```

#### Viewport Culling
```dart
class CullingSystem {
  bool isVisible(PositionComponent component, Rect viewport) {
    return viewport.overlaps(component.toRect());
  }
  
  void updateVisibleComponents() {
    final viewport = camera.visibleWorldRect;
    
    for (final entity in allEntities) {
      entity.isVisible = isVisible(entity, viewport);
      
      // Görünmeyen nesneleri güncelleme
      if (!entity.isVisible) {
        entity.pauseUpdate();
      }
    }
  }
}
```

### Debugging Araçları

```dart
class DebugOverlay extends PositionComponent {
  @override
  void render(Canvas canvas) {
    if (!kDebugMode) return;
    
    // FPS Counter
    final fps = 1.0 / game.dt;
    _drawText(canvas, 'FPS: ${fps.toStringAsFixed(1)}', Vector2(10, 10));
    
    // Entity count
    _drawText(canvas, 'Entities: ${game.children.length}', Vector2(10, 30));
    
    // Player position
    _drawText(canvas, 'Position: ${player.position}', Vector2(10, 50));
  }
}
```

---

## 📄 Lisans

Bu proje **MIT License** altında lisanslanmıştır.

---

## 👥 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen şu adımları izleyin:

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add: Amazing Feature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request açın

---

## 📞 İletişim

**Proje Sahibi**: Snake Empires Team  
**Email**: contact@snakeempires.com  
**Website**: https://snakeempires.com  

---

## 🙏 Teşekkürler

- Flame Engine community
- Flutter team
- Tüm open-source katkıda bulunanlara

---

**⚠️ Not**: Bu proje aktif geliştirme aşamasındadır. Bazı özellikler henüz tamamlanmamış olabilir.

---

Made with ❤️ by Snake Empires Team



flutter run -d chrome