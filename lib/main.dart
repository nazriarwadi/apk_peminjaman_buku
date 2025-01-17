import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: AppRoutes.routes, // Menggunakan routes yang dipisah
    );
  }
}