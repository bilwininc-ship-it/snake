import 'package:connectivity_plus/connectivity_plus.dart';

/// Network information and connectivity checker
/// Ağ bağlantısı kontrolü

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      // connectivity_plus 6.0.0+ returns List<ConnectivityResult>
      // Return the first result or none if empty
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    });
  }
}
