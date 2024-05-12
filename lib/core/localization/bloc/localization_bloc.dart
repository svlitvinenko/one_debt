import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'localization_bloc.freezed.dart';

@freezed
class LocalizationEvent with _$LocalizationEvent {
  const factory LocalizationEvent.initialized() = _Initialized;
  const factory LocalizationEvent.set({required Locale locale}) = _Set;
}

@freezed
class LocalizationState with _$LocalizationState {
  const factory LocalizationState({required Locale locale}) = _LocalizationState;
}

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  static Locale get _defaultLocale => const Locale('en');

  static const String _kLocaleKey = 'admin_panel_locale';

  final SharedPreferences preferences;
  LocalizationBloc(this.preferences) : super(_LocalizationState(locale: _defaultLocale)) {
    on<_Initialized>(_onInitialized);
    on<_Set>(_onSet);
  }

  FutureOr<void> _onInitialized(
    _Initialized event,
    Emitter<LocalizationState> emit,
  ) async {
    final String? stored = preferences.getString(_kLocaleKey)?.toLowerCase().trim();
    final Locale locale = switch (stored) {
      'ru' => const Locale('ru'),
      'en' => const Locale('en'),
      _ => _defaultLocale,
    };
    emit(LocalizationState(locale: locale));
    await preferences.setString(_kLocaleKey, locale.languageCode);
  }

  FutureOr<void> _onSet(
    _Set event,
    Emitter<LocalizationState> emit,
  ) async {
    final Locale locale = switch (event.locale.languageCode) {
      'ru' => const Locale('ru'),
      'en' => const Locale('en'),
      _ => _defaultLocale,
    };
    emit(LocalizationState(locale: locale));
    await preferences.setString(_kLocaleKey, locale.languageCode);
  }
}
