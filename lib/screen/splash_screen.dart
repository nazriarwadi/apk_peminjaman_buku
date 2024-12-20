import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../buttom/button_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Wait for a few seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Navigate directly to the home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ButtonNavbar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.purple, Colors.deepPurple],
              ),
            ),
          ),
          // Animation and logo/text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset('assets/animation/animation_book.json'),
              ),
              const SizedBox(height: 20),
              // Application name or logo
              const Text(
                'Aplikasi Pustaka',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Optional tagline or version
              Text(
                'Temukan buku favorit Anda',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
