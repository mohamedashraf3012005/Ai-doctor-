import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../localization/app_strings.dart';
import '../localization/locale_cubit.dart';

/// Context extensions for quick access to theme, screen, and localization properties.
extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Translates a key based on current active language.
  String translate(String key) {
    final languageCode = read<LocaleCubit>().state.languageCode;
    return AppStrings.get(key, languageCode);
  }

  /// Check if active language direction is RTL / Arabic.
  bool get isArabic => read<LocaleCubit>().isArabic;
}

/// String utility extensions.
extension StringExtension on String {
  /// Capitalizes the first character.
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Truncates the string to [maxLength] appending '…' if needed.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}…';
}

/// DateTime formatting extensions.
extension DateTimeExtension on DateTime {
  /// Formats as 'Jan 15, 2026'.
  String get formattedDate => DateFormat('MMM dd, yyyy').format(this);

  /// Formats as '09:30 AM'.
  String get formattedTime => DateFormat('hh:mm a').format(this);

  /// Formats as 'Jan 15, 2026 at 09:30 AM'.
  String get formattedDateTime => '$formattedDate at $formattedTime';

  /// Returns relative time string like '2 hours ago'.
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
