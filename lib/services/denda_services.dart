import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/denda_models.dart';
import '../services/config.dart'; // Import file config.dart

class FineService {
  Future<List<FineDetail>> fetchFines(String kodePengguna) async {
    final response = await http.get(
      Uri.parse('${Config.apiBaseUrl}/get_denda.php?kode_anggota=$kodePengguna'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        List<dynamic> jsonData = data['data'];
        return jsonData.map((item) => FineDetail.fromJson(item)).toList();
      } else {
        throw Exception('API Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load fines: ${response.statusCode}');
    }
  }
}
