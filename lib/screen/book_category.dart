import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/book_services.dart';
import '../models/books_category.dart';
import '../services/config.dart';
import 'detail_book.dart';

class BookCategoryPage extends StatefulWidget {
  final String category;
  final String categoryName;

  const BookCategoryPage({super.key, required this.category, required this.categoryName});

  @override
  BookCategoryPageState createState() => BookCategoryPageState();
}

class BookCategoryPageState extends State<BookCategoryPage> {
  late Future<List<Book>> _booksFuture;
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _booksFuture = BookService().getBooksByCategory(widget.category);
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    _books = await _booksFuture;
    setState(() {});
  }

  Future<void> _refreshBooks() async {
    setState(() {
      _booksFuture = BookService().getBooksByCategory(widget.category);
    });
    await _loadBooks();
  }

  void _likeBook(int bookId) async {
    final book = _books.firstWhere((b) => b.id == bookId);
    if (book.isLiked) {
      return;
    }

    setState(() {
      book.jumlahLike += 1;
      book.isLiked = true;
    });

    await BookService().likeBook(bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.deepPurple, Colors.purpleAccent],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (snapshot.error is Exception && (snapshot.error as Exception).toString().contains('Tidak ada data pustaka untuk kategori ini')) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.circleExclamation,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Untuk sementara daftar buku di kategori ini belum ada, mohon ditunggu...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.circleExclamation,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Untuk sementara daftar buku di kategori ini belum ada, mohon ditunggu...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List<Book> books = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshBooks,
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  Book book = books[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(bookId: book.id),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                '${Config.imageBaseUrl}/${book.image}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  book.tahun,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(FontAwesomeIcons.solidHeart, size: 16, color: Colors.red),
                                        const SizedBox(width: 5),
                                        Text(book.jumlahLike.toString()),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        book.isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                                        color: book.isLiked ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: book.isLiked ? null : () => _likeBook(book.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
