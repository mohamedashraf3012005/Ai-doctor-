import 'package:connectivity_plus/connectivity_plus.dart';

/// Wrapper around connectivity_plus for checking network availability.
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Returns true if the device has an active network connection.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
