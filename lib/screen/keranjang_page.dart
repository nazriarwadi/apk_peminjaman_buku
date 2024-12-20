// ignore_for_file: unused_field

import 'package:aplikasi_pustaka/screen/pustaka_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/buku.dart';
import '../models/ajukan_peminjaman.dart';
import '../services/maksimal_peminjaman.dart';
import '../services/aturan_pustaka_services.dart';
import '../services/keranjang_services.dart';
import '../services/ajukan_peminjaman.dart';
import '../services/detail_services.dart';
import 'pengajuan_berhasil.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  final AturanPustakaService _aturanPustakaService = AturanPustakaService();
  final BorrowService _borrowService = BorrowService();
  final MaksimalPeminjamanService _maksimalPeminjamanService = MaksimalPeminjamanService();

  int maksimalPeminjaman = 0;
  bool isLoading = true;
  bool isError = false;
  String namaAnggota = '';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');
    if (kodePengguna != null) {
      _fetchMaxBorrowLimit(kodePengguna);
    }
  }

  Future<void> _fetchMaxBorrowLimit(String kodePengguna) async {
    try {
      final response = await _maksimalPeminjamanService.fetchMaksimalPeminjaman(kodePengguna);

      setState(() {
        maksimalPeminjaman = response.maksimalPeminjaman;
        namaAnggota = response.namaAnggota;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _deleteCartItem(String kodePustaka) {
    setState(() {
      _cartService.removeFromCart(kodePustaka);
    });
  }

  void _confirmBorrow() async {
    bool konfirmasi = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Pengajuan"),
          content: const Text("Apakah anda yakin ingin mengajukan peminjaman pustaka ini?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (konfirmasi) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? kodePengguna = prefs.getString('kode_pengguna');

        if (kodePengguna == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kode pengguna tidak ditemukan')),
          );
          return;
        }

        final cartItems = _cartService.getItems();
        final cartPustaka = cartItems.map((item) => {'kode_pustaka': item.kodePustaka}).toList();

        final request = BorrowRequest(
          kodePengguna: kodePengguna,
          cartPustaka: cartPustaka,
        );

        final response = await _borrowService.submitBorrowRequest(request);

        if (response['status'] == 'success') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BorrowSuccessPage(kodePeminjaman: response['kode_peminjaman']),
            ),
          );
          _cartService.clearCart();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengajukan peminjaman: $e')),
        );
      }
    }
  }

  Future<Category?> _fetchCategory(String categoryId) async {
    try {
      final category = await BookService().fetchCategory(categoryId);
      return category;
    } catch (e) {
      debugPrint('Error fetching category: $e');
      return null;
    }
  }

  Future<Author?> _fetchAuthor(String authorId) async {
    try {
      final author = await BookService().fetchAuthor(authorId);
      return author;
    } catch (e) {
      debugPrint('Error fetching author: $e');
      return null;
    }
  }

  Future<Publisher?> _fetchPublisher(String publisherId) async {
    try {
      final publisher = await BookService().fetchPublisher(publisherId);
      return publisher;
    } catch (e) {
      debugPrint('Error fetching publisher: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _cartService.getItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Pustaka', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (isError)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Terjadi kesalahan: $errorMessage',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          else if (maksimalPeminjaman > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD1ECF1),
                  border: Border.all(color: const Color(0xFFBEE5EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Hallo $namaAnggota, Anda dapat meminjam maksimal $maksimalPeminjaman pustaka.',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD1ECF1),
                  border: Border.all(color: const Color(0xFFBEE5EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Hallo $namaAnggota, saat ini Anda telah mencapai batas maksimal peminjaman. Kembalikan terlebih dahulu pustaka yang sedang dipinjam agar dapat melakukan peminjaman berikutnya.',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 20),
                          const Text(
                            'Saat ini keranjang pustaka anda masih kosong.\nSilahkan pilih terlebih dahulu buku yang ingin anda pinjam.',
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            // Optionally handle item tap
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.kodePustaka,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red.shade700),
                                      onPressed: () => _deleteCartItem(item.kodePustaka),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _buildFutureDetailRow(Icons.book, 'Judul', Future.value(item.judulPustaka)),
                                const SizedBox(height: 2),
                                _buildFutureDetailRow(Icons.category, 'Kategori', _fetchCategory(item.namaKategoriPustaka)),
                                const SizedBox(height: 2),
                                _buildFutureDetailRow(Icons.person, 'Penulis', _fetchAuthor(item.namaPenulis)),
                                const SizedBox(height: 2),
                                _buildFutureDetailRow(Icons.business, 'Penerbit', _fetchPublisher(item.namaPenerbit)),
                                const SizedBox(height: 2),
                                _buildDetailRow(Icons.calendar_today, 'Tahun', item.tahun),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _confirmBorrow,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Ajukan Sekarang'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LibraryPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.book_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFutureDetailRow(IconData icon, String label, Future<dynamic> future) {
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
          } else if (snapshot.data is String) {
            value = snapshot.data as String;
          } else {
            value = 'Unknown';
          }
        }
        return _buildDetailRow(icon, label, value);
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}