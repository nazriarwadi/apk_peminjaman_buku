import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'config.dart'; // Import Config

class RegisterService {
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('${Config.apiBaseUrl}/post_registrasi.php'),
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }
}
