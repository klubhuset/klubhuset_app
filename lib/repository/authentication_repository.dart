import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthenticationRepository {
  final String baseUrl;

  AuthenticationRepository({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password, String role) async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      if (kDebugMode) print('Registration error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  Future<bool> logout() async {
    // Hvis du bruger token-baseret auth kan du kalde en API endpoint her til at invalidere token
    // Ellers bare return true for at "rydde" lokalt
    return true;
  }
}
