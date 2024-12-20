import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/books_category.dart';
import '../services/config.dart'; // Import file config.dart

class BookService {
  Future<List<Book>> getBooksByCategory(String category) async {
    final url = '${Config.apiBaseUrl}/get_book_kategori.php?kategori_pustaka=$category';
    print('Requesting URL: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final jsonResponse = json.decode(response.body);

      if (jsonResponse is List) {
        return jsonResponse.map((book) => Book.fromJson(book)).toList();
      } else if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('message')) {
        throw Exception(jsonResponse['message']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<void> likeBook(int bookId) async {
    final url = '${Config.apiBaseUrl}/post_like_book.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id_pustaka': bookId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like the book: ${response.body}');
    }

    final jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] != true) {
      throw Exception('Failed to like the book: ${jsonResponse['message']}');
    }
  }
}
