import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../models/book_detail.dart';
import '../models/buku.dart';
import '../models/keranjang_models.dart';
import '../services/config.dart';
import '../services/detail_services.dart';
import '../services/keranjang_services.dart';
import 'keranjang_page.dart';
import 'login_page.dart';

class BookDetailPage extends StatefulWidget {
  final int bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  BookDetailPageState createState() => BookDetailPageState();
}

class BookDetailPageState extends State<BookDetailPage> {
  late Future<BookDetail> _bookDetail;

  @override
  void initState() {
    super.initState();
    _bookDetail = BookService().fetchBookDetail(widget.bookId);
  }

  Future<void> _fetchData() async {
    setState(() {
      _bookDetail = BookService().fetchBookDetail(widget.bookId);
    });
  }

  Future<void> _onRefresh() async {
    await _fetchData();
  }

  Future<Category?> _fetchCategory(String categoryId) async {
    try {
      final category = await BookService().fetchCategory(categoryId);
      debugPrint('Category: ${category?.name}');
      return category;
    } catch (e) {
      debugPrint('Error fetching category: $e');
      return null;
    }
  }

  Future<Author?> _fetchAuthor(String authorId) async {
    try {
      final author = await BookService().fetchAuthor(authorId);
      debugPrint('Author: ${author?.name}');
      return author;
    } catch (e) {
      debugPrint('Error fetching author: $e');
      return null;
    }
  }

  Future<Publisher?> _fetchPublisher(String publisherId) async {
    try {
      final publisher = await BookService().fetchPublisher(publisherId);
      debugPrint('Publisher: ${publisher?.name}');
      return publisher;
    } catch (e) {
      debugPrint('Error fetching publisher: $e');
      return null;
    }
  }

  Future<void> _addToCart(BookDetail bookDetail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');

    if (kodePengguna == null) {
      _showLoginDialog();
    } else {
      final cartItem = CartItem(
        kodePustaka: bookDetail.kode,
        judulPustaka: bookDetail.title,
        namaKategoriPustaka: bookDetail.kategori.toString(),
        namaPenulis: bookDetail.penulis,
        namaPenerbit: bookDetail.penerbit,
        tahun: bookDetail.tahun,
      );
      CartService().addToCart(cartItem);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Diperlukan'),
        content:
            const Text('Anda perlu login untuk menambahkan item ke keranjang.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<BookDetail>(
          future: _bookDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error.toString()}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Tidak ada data buku'));
            } else {
              final bookDetail = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(bookDetail),
                    _buildDetailsSection(bookDetail),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(BookDetail bookDetail) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(
            '${Config.imageBaseUrl}/${bookDetail.image}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BookDetail bookDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookDetail.title,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          _buildFutureDetailRow(Icons.category, 'Kategori',
              _fetchCategory(bookDetail.kategori.toString())),
          _buildFutureDetailRow(
              Icons.person, 'Penulis', _fetchAuthor(bookDetail.penulis)),
          _buildFutureDetailRow(
              Icons.business, 'Penerbit', _fetchPublisher(bookDetail.penerbit)),
          _buildDetailRow(Icons.calendar_today, 'Tahun', bookDetail.tahun),
          _buildDetailRow(Icons.book, 'Halaman', bookDetail.halaman.toString()),
          _buildDetailRow(
              Icons.storage, 'Jumlah Stok', bookDetail.stok.toString()),
          _buildDetailRow(Icons.location_on, 'Posisi Rak', bookDetail.rak),
          _buildDetailRow(
              Icons.thumb_up, 'Jumlah Like', bookDetail.jumlahLike.toString()),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _addToCart(bookDetail);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
                shadowColor: Colors.deepPurpleAccent,
              ),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                'Masukkan ke Keranjang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureDetailRow(
      IconData icon, String label, Future<dynamic> future) {
    return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        String value = 'Loading...';
        if (snapshot.connectionState == ConnectionState.waiting) {
          value = 'Loading...';
        } else if (snapshot.hasError) {
          value = 'Error';
        } else if (snapshot.hasData) {
          if (snapshot.data is Category) {
            value = (snapshot.data as Category).name;
          } else if (snapshot.data is Author) {
            value = (snapshot.data as Author).name;
          } else if (snapshot.data is Publisher) {
            value = (snapshot.data as Publisher).name;
          } else {
            value = 'Unknown';
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 10),
              Text(
                '$label: ',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
