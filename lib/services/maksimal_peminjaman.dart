import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/maksimal_peminjaman_models.dart';
import 'config.dart'; // Import Config

class MaksimalPeminjamanService {
  Future<MaksimalPeminjaman> fetchMaksimalPeminjaman(String kodePengguna) async {
    final response = await http.get(
      Uri.parse('${Config.apiBaseUrl}/get_maksimalPeminjaman.php?kode_pengguna=$kodePengguna')
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        return MaksimalPeminjaman.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load data from server');
    }
  }
}
