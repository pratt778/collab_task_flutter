import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';

/// Cubit that drives `MaterialApp.themeMode` and persists the choice
/// to `SecureStorageHelper`. State is a plain `ThemeMode` — no custom
/// state class because there's no loading/error to model.
@injectable
class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorageHelper _storage;

  ThemeCubit(this._storage) : super(_initial(_storage));

  static ThemeMode _initial(SecureStorageHelper storage) =>
      storage.getDarkMode() ? ThemeMode.dark : ThemeMode.light;

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _storage.saveDarkMode(next == ThemeMode.dark);
    emit(next);
  }

  void updateTheme(ThemeMode themeMode) {
    _storage.saveDarkMode(themeMode == ThemeMode.dark);
    emit(themeMode);
  }
}
