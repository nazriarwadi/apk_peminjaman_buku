import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class LoginService {
  static String loginUrl = '${Config.apiBaseUrl}/login.php';
  static String penggunaUrl = '${Config.apiBaseUrl}/get_pengguna.php';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Login response: $jsonResponse'); // Debug log
      if (jsonResponse is Map<String, dynamic>) {
        return jsonResponse;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, dynamic>> getPengguna(String username) async {
    final response = await http.post(
      Uri.parse(penggunaUrl),
      body: {'username': username},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Get Pengguna response: $jsonResponse'); // Debug log
      if (jsonResponse is Map<String, dynamic>) {
        return jsonResponse;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to get pengguna');
    }
  }
}