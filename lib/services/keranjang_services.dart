import '../models/keranjang_models.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final List<CartItem> _items = [];

  void addToCart(CartItem item) {
    _items.add(item);
  }

  List<CartItem> getItems() {
    return _items;
  }

  void clearCart() {
    _items.clear();
  }

  void removeFromCart(String kodePustaka) {
    _items.removeWhere((item) => item.kodePustaka == kodePustaka);
  }
}
