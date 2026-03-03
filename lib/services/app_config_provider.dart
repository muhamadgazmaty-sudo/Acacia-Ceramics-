import 'package:flutter/foundation.dart';

class AppConfigProvider extends ChangeNotifier {
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _cart = [];

  String get selectedCategory => _selectedCategory;
  List<Map<String, dynamic>> get cart => _cart;
  int get cartCount => _cart.length;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addToCart(Map<String, dynamic> product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    _cart.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
