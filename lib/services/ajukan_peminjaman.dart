import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ajukan_peminjaman.dart';
import '../services/config.dart'; // Import file config.dart

class BorrowService {
  Future<Map<String, dynamic>> submitBorrowRequest(BorrowRequest request) async {
    final response = await http.post(
      Uri.parse('${Config.apiBaseUrl}/post_ajukan_peminjaman.php'), // Gunakan Config.apiBaseUrl
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    print('Response Body: ${response.body}'); // Tambahkan log ini

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit borrow request');
    }
  }
}
