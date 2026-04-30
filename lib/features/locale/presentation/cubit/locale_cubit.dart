import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';

/// Cubit that drives `MaterialApp.locale` and persists the choice
/// to `SecureStorageHelper`. State is a plain `Locale` — no custom
/// state class because there's no loading/error to model.
@injectable
class LocaleCubit extends Cubit<Locale> {
  final SecureStorageHelper _storage;

  LocaleCubit(this._storage) : super(_initial(_storage));

  static Locale _initial(SecureStorageHelper storage) =>
      Locale(storage.getLocale());

  void setLocale(Locale locale) {
    _storage.saveLocale(locale.languageCode);
    emit(locale);
  }

  void toggle() {
    final next = state.languageCode == 'en'
        ? const Locale('ne')
        : const Locale('en');
    setLocale(next);
  }
}
