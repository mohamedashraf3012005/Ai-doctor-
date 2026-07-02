import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing locale switching between English and Arabic.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  /// Toggle between English and Arabic.
  void toggleLocale() {
    emit(state.languageCode == 'en' ? const Locale('ar') : const Locale('en'));
  }

  /// Set a specific locale.
  void setLocale(String languageCode) {
    emit(Locale(languageCode));
  }

  /// Whether the current locale is Arabic.
  bool get isArabic => state.languageCode == 'ar';

  /// Current language code.
  String get langCode => state.languageCode;
}
