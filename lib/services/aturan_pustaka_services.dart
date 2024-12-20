import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aturan_pustaka_models.dart';
import '../services/config.dart'; // Import file config.dart

class AturanPustakaService {
  Future<AturanPustaka> fetchAturanPustaka() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_aturan_pustaka.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse['status'] == 'success') {
        final List<dynamic> data = jsonResponse['data'];
        if (data.isNotEmpty) {
          return AturanPustaka.fromJson(data[0]);
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load aturan pustaka');
    }
  }
}
