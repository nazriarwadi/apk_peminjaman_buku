import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Menu Lainnya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.transparent,
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
        padding: const EdgeInsets.all(16.0), // Reduced padding for a more compact look
        child: ListView(
          children: [
            _buildMenuCard(context, 'Keranjang', Icons.shopping_cart, Colors.blue, '/cart'),
            _buildMenuCard(context, 'Peminjaman', Icons.book, Colors.green, '/borrow'),
            _buildMenuCard(context, 'Keterlambatan', Icons.timer, Colors.orange, '/late'),
            _buildMenuCard(context, 'Denda', Icons.money, Colors.red, '/fine'),
            _buildMenuCard(context, 'Profile', Icons.person, Colors.purple, '/profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, String routeName) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners
      ),
      elevation: 8, // Increased shadow for more depth
      margin: const EdgeInsets.symmetric(vertical: 8), // Reduced vertical margin
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Added horizontal padding
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            radius: 28, // Increased radius for a better visual
            child: Icon(icon, color: Colors.white, size: 30), // Increased icon size
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20, // Increased font size for better readability
              fontWeight: FontWeight.w600, // Slightly lighter weight for a modern look
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 20), // Slightly smaller trailing icon
          onTap: () {
            Navigator.pushNamed(context, routeName); // Navigate to the specified route
          },
          contentPadding: EdgeInsets.zero, // Remove extra padding for a more compact look
        ),
      ),
    );
  }
}
