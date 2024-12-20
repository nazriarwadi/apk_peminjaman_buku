import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/keterlambatan_models.dart';
import '../services/config.dart'; // Import file config.dart

class KeterlambatanService {
  Future<List<Keterlambatan>> fetchKeterlambatan(String kodePengguna) async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_keterlambatan.php?kode_anggota=$kodePengguna'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        List<dynamic> jsonData = jsonResponse['data'];
        return jsonData.map((item) => Keterlambatan.fromJson(item)).toList();
      } else {
        throw Exception('API Error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load keterlambatan');
    }
  }
}
