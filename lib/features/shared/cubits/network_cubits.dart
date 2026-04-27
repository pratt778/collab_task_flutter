// lib/cubits/network_cubit.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NetworkStatus { online, offline }

class NetworkCubit extends Cubit<NetworkStatus> {
  NetworkCubit() : super(NetworkStatus.offline) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  
  // 🔥 Fires ONLY when transitioning from offline → online
  final StreamController<void> _recoveryStreamController = StreamController<void>.broadcast();
  Stream<void> get onRecoveryStream => _recoveryStreamController.stream;

  Timer? _debounceTimer;

  Future<void> _init() async {
    await _checkConnection();
    _connectivity.onConnectivityChanged.listen((_) => _debounceCheck());
  }

  void _debounceCheck() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), _checkConnection);
  }

  Future<void> _checkConnection() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    final newStatus = hasInternet ? NetworkStatus.online : NetworkStatus.offline;

    if (newStatus != state) {
      final wasOffline = state == NetworkStatus.offline;
      emit(newStatus);

      // 🎯 Trigger recovery stream ONLY on offline → online transition
      if (wasOffline && newStatus == NetworkStatus.online) {
        _recoveryStreamController.add(null);
      }
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _recoveryStreamController.close();
    return super.close();
  }
}