import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:klubhuset/repository/authentication_repository.dart';
import 'package:klubhuset/services/secure_storage_service.dart';

enum UserRole { player, teamOwner, admin }

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.player:
      return 'Player';
    case UserRole.teamOwner:
      return 'Team Owner';
    case UserRole.admin:
      return 'Admin';
  }
}

class AuthService with ChangeNotifier {
  UserDetails? _currentUser;

  UserDetails? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    final result = await AuthenticationRepository.login(email, password);

    if (result['success'] == true) {
      final token = result['data']['token'];
      await SecureStorageService.setToken(token);

      // TODO: Hent rigtig brugerdata via /me, fx:
      // final userInfo = await AuthenticationRepository.getCurrentUser();
      // _currentUser = UserDetails.fromJson(userInfo);

      _currentUser = UserDetails(
          id: 1,
          name: 'Testersen',
          email: email,
          isTeamOwner: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());

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
      notifyListeners();
      return true;
    } else {
      debugPrint('Logout fejl');
      return false;
    }
  }
}
