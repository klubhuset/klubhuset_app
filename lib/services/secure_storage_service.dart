import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked),
  );

  static Future<void> setToken(String token) async {
    await _storage.delete(key: 'token');
    await _storage.write(key: 'token', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
