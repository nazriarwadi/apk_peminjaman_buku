import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../buttom/category_section.dart';
import '../services/home_services.dart';
import '../models/home.dart';
import 'book_list_page.dart';
import 'search_result_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<BookHome>> _newlyReleasedBooks;
  late Future<List<BookHome>> _favoriteBooks;
  late Future<List<BookHome>> _mostReadBooks;
  String? _namaPengguna;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadUserProfile();
  }

  Future<void> _fetchData() async {
    setState(() {
      _newlyReleasedBooks = BookService().getBooksByYear();
      _favoriteBooks = BookService().getBooksByLikes();
      _mostReadBooks = BookService().getBooksByStock();
    });
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaPengguna = prefs.getString('nama_pengguna');
    });
  }

  void _navigateToBookListPage(String title, Future<List<BookHome>> booksFuture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookListPage(title: title, booksFuture: booksFuture),
      ),
    );
  }

  void _navigateToSearchResults(String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(keyword: keyword),
      ),
    ).then((_) {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategorySection('Buku yang baru dirilis', _newlyReleasedBooks),
                        _buildCategorySection('Buku Favorit', _favoriteBooks),
                        _buildCategorySection('Buku Banyak Stok', _mostReadBooks),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 190.0,
      pinned: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false, // Disable the back button
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          collapseMode: CollapseMode.parallax,
          background: _buildHeaderBackground(),
        ),
      ),
      actions: [
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildHeaderBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildWelcomeMessage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: _buildSearchBar(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi, ${_namaPengguna ?? 'User'}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '👋',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Selamat datang! Nikmati pengalaman \nmembaca yang menyenangkan dengan koleksi kami',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari buku...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                onSubmitted: (String keyword) {
                  if (keyword.trim().isNotEmpty) {
                    _navigateToSearchResults(keyword.trim());
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.deepPurple),
            onPressed: () {
              String keyword = _searchController.text.trim();
              if (keyword.isNotEmpty) {
                _navigateToSearchResults(keyword);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 46.0,
      height: 46.0,
      margin: const EdgeInsets.only(right: 20, top: 10),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white, size: 22.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(String title, Future<List<BookHome>> booksFuture) {
    return FutureBuilder<List<BookHome>>(
      future: booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada buku yang tersedia'));
        } else {
          return CategorySection(
            title: title,
            books: snapshot.data!,
            onSeeAllPressed: () => _navigateToBookListPage(title, booksFuture),
          );
        }
      },
    );
  }
}
