import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing dark/light theme mode switching.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  /// Toggle between light and dark mode.
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  /// Whether the current mode is dark.
  bool get isDark => state == ThemeMode.dark;
}
