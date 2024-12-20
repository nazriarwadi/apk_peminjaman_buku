import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_detail.dart';
import '../models/buku.dart';
import '../services/config.dart'; // Import file config.dart

class BookService {
  Future<BookDetail> fetchBookDetail(int bookId) async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_detail_book.php?id_pustaka=$bookId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return BookDetail.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load book detail');
    }
  }

  Future<Category?> fetchCategory(String categoryId) async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_kategori.php?id_kategori_pustaka=$categoryId'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return Category.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<Author?> fetchAuthor(String authorId) async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_penulis.php?id_penulis=$authorId'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return Author.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load author');
    }
  }

  Future<Publisher?> fetchPublisher(String publisherId) async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/get_penerbit.php?id_penerbit=$publisherId'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return Publisher.fromJson(jsonResponse);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load publisher');
    }
  }
}
