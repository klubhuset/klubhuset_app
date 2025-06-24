import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:klubhuset/services/secure_storage_service.dart';

class AuthenticationRepository {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    await dotenv.load(); // Initialize dotenv

    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/authentication/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save the token securely
        await SecureStorageService.setToken(data['token']);

        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login fejlede'
        };
      }
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      return {
        'success': false,
        'message': 'Der skete en fejl under login. Prøv igen.'
      };
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password, int roleId) async {
    await dotenv.load(); // Initialize dotenv

    final url =
        Uri.parse('${dotenv.env['API_BASE_URL']}/authentication/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'roleId': roleId,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Registrering fejlede'
        };
      }
    } catch (e) {
      if (kDebugMode) print('Registration error: $e');
      return {
        'success': false,
        'message': 'Der skete en fejl under registering. Prøv igen.'
      };
    }
  }

  static Future<bool> logout() async {
    await SecureStorageService.deleteToken();

    return true;
  }
}
