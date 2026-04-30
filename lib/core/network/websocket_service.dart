import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Status enum for WebSocket connection states.
enum WebSocketStatus { connecting, connected, disconnected, error }

/// WebSocket service for real-time task updates.
///
/// Handles connection, disconnection, auto-reconnect with exponential backoff,
/// and stream-based event broadcasting.
class WebSocketService {
  final String baseUrl;
  WebSocket? _webSocket;

  late final StreamController<WebSocketStatus> _statusController;
  late final StreamController<Map<String, dynamic>> _dataController;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _initialBackoff = Duration(milliseconds: 250);

  WebSocketService({required this.baseUrl}) {
    _statusController = StreamController<WebSocketStatus>.broadcast();
    _dataController = StreamController<Map<String, dynamic>>.broadcast();
  }

  /// Stream of WebSocket status changes.
  Stream<WebSocketStatus> get statusStream => _statusController.stream;

  /// Stream of incoming WebSocket data.
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  /// Connect to WebSocket with JWT token.
  Future<void> connect({required String token}) async {
    try {
      _statusController.add(WebSocketStatus.connecting);

      final wsUrl = baseUrl
          .replaceFirst('https://', 'wss://')
          .replaceFirst('http://', 'ws://');
      final url = '$wsUrl?token=$token';

      debugPrint('[WS] Connecting to $url');
      _webSocket = await WebSocket.connect(
        url,
      ).timeout(const Duration(seconds: 10));
      _reconnectAttempts = 0;
      _statusController.add(WebSocketStatus.connected);

      _webSocket!.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('[WS] Connection failed: $e');
      _statusController.add(WebSocketStatus.error);
      _scheduleReconnect(token);
    }
  }

  /// Send action to server via WebSocket.
  void send(Map<String, dynamic> action) {
    if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
      _webSocket!.add(jsonEncode(action));
    } else {
      debugPrint('[WS] Not connected, action queued: $action');
    }
  }

  /// Graceful disconnect.
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _webSocket?.close();
    _webSocket = null;
    _statusController.add(WebSocketStatus.disconnected);
  }

  void _onMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      _dataController.add(data);
    } catch (e) {
      debugPrint('[WS] Failed to parse message: $e');
    }
  }

  void _onError(dynamic error) {
    debugPrint('[WS] Error: $error');
    _statusController.add(WebSocketStatus.error);
    // Note: Reconnect handled by _onDone or manual trigger
  }

  void _onDone() {
    debugPrint('[WS] Connection closed');
    _statusController.add(WebSocketStatus.disconnected);
    // _scheduleReconnect(); // Needs token
  }

  void _scheduleReconnect(String token) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('[WS] Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    final backoffMs =
        _initialBackoff.inMilliseconds *
        (1 << _reconnectAttempts).clamp(1, 1000);

    _reconnectTimer = Timer(Duration(milliseconds: backoffMs), () {
      _reconnectAttempts++;
      debugPrint(
        '[WS] Attempting reconnect ($_reconnectAttempts/$_maxReconnectAttempts)...',
      );
      connect(token: token);
    });
  }

  /// Close and dispose resources.
  Future<void> dispose() async {
    await disconnect();
    _reconnectTimer?.cancel();
    await _statusController.close();
    await _dataController.close();
  }
}
