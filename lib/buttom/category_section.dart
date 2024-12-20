import 'package:flutter/material.dart';
import '../models/home.dart';
import 'book_card.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key, required this.title, required this.books, required this.onSeeAllPressed});

  final List<BookHome> books;
  final String title;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.purpleAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: onSeeAllPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(bookHome: books[index]);
            },
          ),
        ),
      ],
    );
  }
}