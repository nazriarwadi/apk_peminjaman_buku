import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/library_item.dart';
import '../services/config.dart'; // Import file config.dart

class LibraryService {
  final String apiUrl = '${Config.apiBaseUrl}/get_pustaka.php';

  Future<List<LibraryItem>> fetchLibraryItems() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LibraryItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load library items');
    }
  }
}