import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home.dart';
import '../services/config.dart'; // Import file config.dart

class BookService {
  Future<List<BookHome>> getBooksByYear() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_newbuku.php'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((book) => BookHome.fromJson(book)).toList();
      } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('message')) {
        throw Exception(jsonResponse['message']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<List<BookHome>> getBooksByLikes() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_likeBuku.php'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((book) => BookHome.fromJson(book)).toList();
      } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('message')) {
        throw Exception(jsonResponse['message']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<List<BookHome>> getBooksByStock() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_stokBuku.php'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        return jsonResponse.map((book) => BookHome.fromJson(book)).toList();
      } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('message')) {
        throw Exception(jsonResponse['message']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<List<BookHome>> searchBooks(String keyword) async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/search_books.php?keyword=$keyword'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is List) {
        return data.map((json) => BookHome.fromJson(json)).toList();
      } else if (data is Map) {
        if (data.containsKey('message') && data['message'] == 'Tidak ada buku yang ditemukan') {
          return [];
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load books');
    }
  }
}
