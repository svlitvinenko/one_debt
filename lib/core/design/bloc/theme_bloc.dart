import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_bloc.freezed.dart';

@freezed
class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.initialized() = _Initialized;
  const factory ThemeEvent.set({required ThemeMode mode}) = _Set;
}

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({required ThemeMode mode}) = _ThemeState;
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const ThemeMode _kDefaultMode = ThemeMode.light;

  static const String _kThemeModeKey = 'admin_panel_theme_mode';

  final SharedPreferences preferences;
  ThemeBloc(this.preferences) : super(const ThemeState(mode: _kDefaultMode)) {
    on<_Initialized>(_onInitialized);
    on<_Set>(_onSet);
  }

  FutureOr<void> _onInitialized(
    _Initialized event,
    Emitter<ThemeState> emit,
  ) async {
    final String? stored = preferences.getString(_kThemeModeKey)?.toLowerCase().trim();
    final ThemeMode mode = switch (stored) {
      'system' => ThemeMode.system,
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => _kDefaultMode,
    };
    emit(ThemeState(mode: mode));
    await preferences.setString(_kThemeModeKey, mode.name);
  }

  FutureOr<void> _onSet(
    _Set event,
    Emitter<ThemeState> emit,
  ) async {
    final ThemeMode mode = event.mode;
    emit(ThemeState(mode: mode));
    await preferences.setString(_kThemeModeKey, mode.name);
  }
}
