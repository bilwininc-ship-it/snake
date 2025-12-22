/// Firebase core service
/// Firebase temel servisi
/// 
/// NOT: Firebase'i kullanmak için:
/// 1. pubspec.yaml'a firebase paketlerini ekleyin:
///    - firebase_core: ^3.6.0
///    - firebase_analytics: ^11.3.3
///    - firebase_crashlytics: ^4.1.3
///    - cloud_firestore: ^5.4.4 (isteğe bağlı)
/// 
/// 2. Firebase Console'dan projenizi oluşturun:
///    https://console.firebase.google.com/
/// 
/// 3. FlutterFire CLI ile yapılandırın:
///    dart pub global activate flutterfire_cli
///    flutterfire configure
/// 
/// 4. Bu dosyadaki yorumları kaldırıp aktif edin

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // flutterfire configure ile oluşturulacak

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isInitialized = false;

  /// Initialize Firebase
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Firebase'i başlat
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      _isInitialized = true;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Check if Firebase is initialized
  bool get isInitialized => _isInitialized;
}
