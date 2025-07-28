import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
  );

  // ------------------------
  // Token methods
  // ------------------------

  // Store auth token
  static Future<void> setToken(String token) async {
    await _storage.delete(key: 'token');
    await _storage.write(key: 'token', value: token);
  }

  // Delete auth token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  // Read auth token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // ------------------------
  // User info methods
  // ------------------------

  // Save user information (ID, name, role)
  static Future<void> setUserInfo({
    required int id,
    required String name,
    required int roleId,
  }) async {
    await _storage.write(key: 'userId', value: id.toString());
    await _storage.write(key: 'userName', value: name);
    await _storage.write(key: 'roleId', value: roleId.toString());
  }

  // Get user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  // Get user name
  static Future<String?> getUserName() async {
    return await _storage.read(key: 'userName');
  }

  // Get user role
  static Future<String?> getUserRole() async {
    return await _storage.read(key: 'roleId');
  }

  // Delete all user info (used on logout)
  static Future<void> clearUserData() async {
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'userName');
    await _storage.delete(key: 'roleId');
    await deleteToken(); // Also remove token
  }
}
