import 'package:flutter/cupertino.dart';
import 'package:kopa/model/user_details.dart';
import 'package:kopa/repository/authentication_repository.dart';
import 'package:kopa/services/secure_storage_service.dart';

class AuthService with ChangeNotifier {
  UserDetails? _currentUser;

  UserDetails? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Retrieve current user
  Future<UserDetails?> getCurrentUser() async {
    try {
      final cachedUser = await SecureStorageService.getUserInfo();
      if (cachedUser != null) {
        _currentUser = cachedUser;
        notifyListeners();
        return _currentUser;
      }

      final apiUser = await AuthenticationRepository.getCurrentUser();
      _currentUser = apiUser;

      await SecureStorageService.setUserInfo(apiUser);

      notifyListeners();
      return _currentUser;
    } catch (e) {
      debugPrint('Fejl ved hentning af bruger: $e');
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    final result = await AuthenticationRepository.login(email, password);

    if (result['success'] == true) {
      final token = result['data']['token'];
      await SecureStorageService.setToken(token);

      final apiUser = await AuthenticationRepository.getCurrentUser();
      await SecureStorageService.setUserInfo(apiUser);

      notifyListeners();
      return true;
    } else {
      _currentUser = null;
      debugPrint('Login fejlede ${result['message']}');
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password, int roleId) async {
    final result = await AuthenticationRepository.register(
      name,
      email,
      password,
      roleId,
    );

    if (result['success'] == true) {
      _currentUser = UserDetails.fromJson(result['data']);
      notifyListeners();
    } else {
      debugPrint('Registreringsfejl: ${result['message']}');
    }

    return result;
  }

  Future<bool> logout() async {
    final success = await AuthenticationRepository.logout();

    if (success) {
      _currentUser = null;
      await SecureStorageService.clearUserData();
      await SecureStorageService.deleteToken();
      notifyListeners();
      return true;
    } else {
      debugPrint('Logout fejl');
      return false;
    }
  }
}
