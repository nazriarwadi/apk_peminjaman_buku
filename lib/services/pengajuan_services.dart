import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pengajuan_models.dart';
import 'config.dart'; // Import Config

class BorrowSuccessService {
  Future<BorrowSuccess> fetchBorrowSuccess(String kodePeminjaman) async {
    final response = await http.get(
      Uri.parse('${Config.apiBaseUrl}/get_peminjaman_sukses.php?kode_peminjaman=$kodePeminjaman'),
    );

    print('Response Body: ${response.body}'); // Tambahkan log ini

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return BorrowSuccess.fromJson(jsonResponse['data']);
      } else {
        throw Exception('API Error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load borrow success data: ${response.statusCode}');
    }
  }
}
