import 'package:flutter/material.dart';
import '../screen/register_page.dart';
import '../screen/login_page.dart';
import '../screen/search_result_page.dart';
import '../screen/denda_page.dart';
import '../screen/keranjang_page.dart';
import '../screen/keterlambatan_page.dart';
import '../screen/peminjaman_page.dart';
import '../screen/profile_page.dart';
import '../buttom/button_navbar.dart';

class AppRoutes {
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String borrow = '/borrow';
  static const String late = '/late';
  static const String fine = '/fine';
  static const String profile = '/profile';
  static const String search = '/search';

  static Map<String, WidgetBuilder> routes = {
    register: (context) => const RegisterPage(),
    login: (context) => const LoginPage(),
    home: (context) => const ButtonNavbar(),
    cart: (context) => const CartPage(),
    borrow: (context) => const BorrowPage(),
    late: (context) => const KeterlambatanPage(),
    fine: (context) => const FinePage(),
    profile: (context) => const ProfilePage(),
    search: (context) => const SearchResultPage(keyword: ''),
  };
}
