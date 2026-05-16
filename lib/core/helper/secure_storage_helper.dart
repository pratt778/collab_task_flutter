import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/config/constants/api_constant.dart';

@lazySingleton
class SecureStorageHelper {
  static final SecureStorageHelper _instance = SecureStorageHelper._internal();

  factory SecureStorageHelper() {
    return _instance;
  }

  SecureStorageHelper._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late Map<String, String> _cache;

  Future<void> init() async {
    _cache = await _storage.readAll();
  }

  void saveToken(String token) {
    _cache['token'] = token;
    _storage.write(key: 'token', value: token);
  }

  String getToken() {
    return _cache['token'] ?? '';
  }

  void saveAccountInfo(String accountInfo) {
    _cache['accountInfo'] = accountInfo;
    _storage.write(key: 'accountInfo', value: accountInfo);
  }

  String getAccountInfo() {
    return _cache['accountInfo'] ?? '';
  }

  void savePhoneNumber(String phoneNumber) {
    _cache['phoneNumber'] = phoneNumber;
    _storage.write(key: 'phoneNumber', value: phoneNumber);
  }

  String getPhoneNumber() {
    return _cache['phoneNumber'] ?? '';
  }

  void saveDeviceToken(String token) {
    _cache['deviceToken'] = token;
    _storage.write(key: 'deviceToken', value: token);
  }

  String getDeviceToken() {
    return _cache['deviceToken'] ?? '';
  }

  Future logOut() async {
    _cache.remove('userName');
    _cache.remove('userCode');
    _cache.remove('token');

    await _storage.delete(key: 'userName');
    await _storage.delete(key: 'userCode');
    await _storage.delete(key: 'token');
  }

  bool isUserLoggedIn() {
    // return _cache.containsKey('token') && _cache.containsKey('userCode');
    return _cache.containsKey('userCode');
  }

  bool isAppPreviouslyUsed() {
    return _cache['app_installed'] == 'true';
  }

  void appInstalled() {
    _cache['app_installed'] = 'true';
    _storage.write(key: 'app_installed', value: 'true');
  }

  void saveUserCode(String userCode) {
    _cache['userCode'] = userCode;
    _storage.write(key: 'userCode', value: userCode);
  }

  String getUserCode() {
    return _cache['userCode'] ?? '';
  }

  void saveUserName(String? id) {
    _cache['userName'] = id ?? '';
    _storage.write(key: 'userName', value: id ?? '');
  }

  String getUserName() {
    return _cache['userName'] ?? '';
  }

  void saveUuid(int? id) {
    _cache['uuid'] = (id ?? 0).toString();
    _storage.write(key: 'uuid', value: (id ?? 0).toString());
  }

  void saveLocale(String languageCode) {
    _cache['language_code'] = languageCode;
    _storage.write(key: 'language_code', value: languageCode);
  }

  String getLocale() {
    return _cache['language_code'] ?? 'en';
  }

  /// Chucker (network debug) toggle. Only used in non-production flavors.
  /// Defaults to true when not set so testers have Chucker on by default.
  void saveChuckerEnabled(bool enabled) {
    _cache['chucker_enabled'] = enabled.toString();
    _storage.write(key: 'chucker_enabled', value: enabled.toString());
  }

  bool getChuckerEnabled() {
    return (_cache['chucker_enabled'] ?? 'true') == 'true';
  }

  /// API host (e.g. `https://diyalodev.com`) chosen via the dev IP-config
  /// screen. Stored WITHOUT the `/api` suffix. Defaults to the dev host.
  void saveBaseIp(String host) {
    _cache['base_ip'] = host;
    _storage.write(key: 'base_ip', value: host);
  }

  String getBaseIp() {
    return _cache['base_ip'] ?? ApiConstants.devIp;
  }

  /// Dark mode toggle. Defaults to false (light mode) when not set.
  void saveDarkMode(bool enabled) {
    _cache['dark_mode'] = enabled.toString();
    _storage.write(key: 'dark_mode', value: enabled.toString());
  }

  bool getDarkMode() {
    return _cache['dark_mode'] == 'true';
  }

  void debugDump() {
    debugPrint('========== SECURE STORAGE CACHE DUMP ==========');
    if (_cache.isEmpty) {
      debugPrint('Cache is empty. Did you forget to call init()?');
    } else {
      _cache.forEach((key, value) {
        // We mask the token for security so it doesn't leak in logs
        if (key.contains('token') || key.contains('Token')) {
          debugPrint(
            '$key: ${value.length > 10 ? "${value.substring(0, 10)}..." : value}',
          );
        } else {
          debugPrint('$key: $value');
        }
      });
    }
    debugPrint('===============================================');
  }
}
