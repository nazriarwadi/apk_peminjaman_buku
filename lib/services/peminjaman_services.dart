import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/peminjaman_models.dart';
import 'config.dart'; // Import Config

class BookLoanService {
  Future<List<BookLoan>> fetchBookLoans(String kodePengguna) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/get_riwayat_peminjaman.php?kode_anggota=$kodePengguna'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Tambahkan debug log

        if (data['status'] == 'success') {
          List<dynamic> jsonData = data['data'];
          return jsonData.map((item) => BookLoan.fromJson(item)).toList();
        } else {
          throw Exception('API Error: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load book loans: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching book loans: $e');
      rethrow;
    }
  }
}
