import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../localization/locale_cubit.dart';

/// Centralized form validation helpers with localization support.
class Validators {
  Validators._();

  /// Whether the current context language is Arabic.
  static bool _isArabic(BuildContext? context) {
    if (context == null) return false;
    try {
      return context.read<LocaleCubit>().isArabic;
    } catch (_) {
      return false;
    }
  }

  /// Returns a validator for email that is locale-aware.
  static String? Function(String?) emailValidator(BuildContext context) {
    return (String? value) {
      final ar = _isArabic(context);
      if (value == null || value.trim().isEmpty) {
        return ar ? 'البريد الإلكتروني مطلوب' : 'Email is required';
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return ar ? 'أدخل بريد إلكتروني صحيح' : 'Enter a valid email address';
      }
      return null;
    };
  }

  /// Returns a validator for password that is locale-aware.
  static String? Function(String?) passwordValidator(BuildContext context) {
    return (String? value) {
      final ar = _isArabic(context);
      if (value == null || value.isEmpty) {
        return ar ? 'كلمة المرور مطلوبة' : 'Password is required';
      }
      if (value.length < 6) {
        return ar
            ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
            : 'Password must be at least 6 characters';
      }
      return null;
    };
  }

  /// Returns a validator for phone that is locale-aware.
  static String? Function(String?) phoneValidator(BuildContext context) {
    return (String? value) {
      final ar = _isArabic(context);
      if (value == null || value.trim().isEmpty) {
        return ar ? 'رقم الهاتف مطلوب' : 'Phone number is required';
      }
      final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
      if (digitsOnly.length < 8 || digitsOnly.length > 15) {
        return ar ? 'أدخل رقم هاتف صحيح' : 'Enter a valid phone number';
      }
      return null;
    };
  }

  /// Returns a validator for username that is locale-aware.
  static String? Function(String?) usernameValidator(BuildContext context) {
    return (String? value) {
      final ar = _isArabic(context);
      if (value == null || value.trim().isEmpty) {
        return ar ? 'اسم المستخدم مطلوب' : 'Username is required';
      }
      return null;
    };
  }

  // ─── Legacy static methods (kept for backward-compatibility) ────

  /// Validates an email address format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a password with minimum 6 characters.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates that a field is not empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Locale-aware required field validator.
  static String? Function(String?) requiredValidator(
      BuildContext context, String fieldName) {
    return (String? value) {
      final ar = _isArabic(context);
      if (value == null || value.trim().isEmpty) {
        return ar ? '$fieldName مطلوب' : '$fieldName is required';
      }
      return null;
    };
  }

  /// Validates a phone number (basic: 8-15 digits).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 8 || digitsOnly.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validates a username is non-empty.
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    return null;
  }
}
