import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing authentication tokens and user session data.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // ─── Keys ──────────────────────────────────────────────────
  static const _tokenKey = 'care360_token';
  static const _roleKey = 'care360_role';
  static const _userIdKey = 'care360_user_id';
  static const _userNameKey = 'care360_user_name';
  static const _userEmailKey = 'care360_user_email';
  static const _userPhoneKey = 'care360_user_phone';

  // ─── Token ─────────────────────────────────────────────────
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  // ─── Session ───────────────────────────────────────────────
  Future<void> saveSession({
    required String token,
    required String role,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
  }) async {
    await saveToken(token);
    await _storage.write(key: _roleKey, value: role);
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: userId);
    }
    if (userName != null) {
      await _storage.write(key: _userNameKey, value: userName);
    }
    if (userEmail != null) {
      await _storage.write(key: _userEmailKey, value: userEmail);
    }
    if (userPhone != null) {
      await _storage.write(key: _userPhoneKey, value: userPhone);
    }
  }

  Future<String?> getRole() => _storage.read(key: _roleKey);
  Future<String?> getUserId() => _storage.read(key: _userIdKey);
  Future<String?> getUserName() => _storage.read(key: _userNameKey);
  Future<String?> getUserEmail() => _storage.read(key: _userEmailKey);
  Future<String?> getUserPhone() => _storage.read(key: _userPhoneKey);

  /// Returns true if a valid session token exists.
  Future<bool> get isLoggedIn async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clears all stored session data.
  Future<void> clearAll() => _storage.deleteAll();
}
