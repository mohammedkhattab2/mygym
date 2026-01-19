import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Network connectivity checker
/// 
/// Provides methods to check if the device has an active network connection.
/// Uses connectivity_plus package for platform-agnostic connectivity detection.
abstract class NetworkInfo {
  /// Check if the device is connected to the internet
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using connectivity_plus
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    // Check if any connection type indicates connectivity
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }
}

/// Factory method for injectable
@module
abstract class ConnectivityModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}