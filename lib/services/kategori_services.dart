import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../services/config.dart'; // Import file config.dart

class KategoriService {
  Future<List<Category>> getKategoriPustaka() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_kategori_pustaka.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Debugging: Print data to verify the structure
      print(data);
      try {
        return data.map((json) => Category.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Failed to parse categories: $e');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
