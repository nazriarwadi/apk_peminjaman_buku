import 'package:flutter/material.dart';
import '../services/kategori_services.dart';
import '../models/category.dart';
import 'book_category.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Book Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.deepPurple,
                Colors.purpleAccent,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: const BookList(),
      ),
    );
  }
}

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  BookListState createState() => BookListState();
}

class BookListState extends State<BookList> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _categoriesFuture = KategoriService().getKategoriPustaka();
    });
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Bisnis':
        return Icons.business;
      case 'Komputer':
        return Icons.computer;
      case 'Pariwisata':
        return Icons.card_travel;
      case 'Pendidikan':
        return Icons.school;
      case 'Agama':
        return Icons.book;
      case 'Novel':
        return Icons.bookmark;
      case 'Kesehatan':
        return Icons.local_hospital;
      case 'Sosial':
        return Icons.people;
      case 'Politik':
        return Icons.gavel;
      case 'Sejarah':
        return Icons.history;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        } else {
          List<Category> categories = snapshot.data!;

          // Custom card sizes to create an aesthetic variation
          List<double> cardHeights = [200, 180, 200, 180, 200];
          List<double> cardWidths = [160, 200, 160, 200, 160];

          return RefreshIndicator(
            onRefresh: _fetchCategories,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                double cardHeight = cardHeights[index % cardHeights.length];
                double cardWidth = cardWidths[index % cardWidths.length];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookCategoryPage(
                          category: categories[index].id.toString(),
                          categoryName: categories[index].name,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: cardHeight,
                      width: cardWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.withOpacity(0.8),
                            Colors.purpleAccent.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 40,
                            child: Icon(
                              _getIconForCategory(categories[index].name),
                              color: Colors.deepPurple,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            categories[index].name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
