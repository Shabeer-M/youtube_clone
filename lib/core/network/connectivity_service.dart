import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionChangeController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  Future<void> _connectionChange(List<ConnectivityResult> result) async {
    bool hasConnection = !result.contains(ConnectivityResult.none);
    _connectionChangeController.add(hasConnection);
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void dispose() {
    _connectionChangeController.close();
  }
}
