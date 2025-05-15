import 'package:flutter/cupertino.dart';
import 'package:klubhuset/repository/authentication_repository.dart';

// Bruger model (uændret)
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  String? teamId;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.teamId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      name: json['name'],
      role:
          json['role'] == 'teamLeader' ? UserRole.teamLeader : UserRole.player,
      teamId: json['teamId'],
    );
  }
}

enum UserRole { player, teamLeader }

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.player:
      return 'player';
    case UserRole.teamLeader:
      return 'teamLeader';
  }
}

class AuthService with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    final result = await AuthenticationRepository.login(email, password);

    if (result['success'] == true) {
      _currentUser = User.fromJson(result['data']);
      notifyListeners();
      return true;
    } else {
      _currentUser = null;
      debugPrint('Login fejl: ${result['message']}');
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password, UserRole role) async {
    final result = await AuthenticationRepository.register(
      name,
      email,
      password,
      userRoleToString(role),
    );

    if (result['success'] == true) {
      _currentUser = User.fromJson(result['data']);
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
