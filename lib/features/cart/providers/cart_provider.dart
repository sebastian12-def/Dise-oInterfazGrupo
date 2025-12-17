import 'package:flutter/foundation.dart';
import '../../shared/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.name == product.name);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(
        name: product.name,
        price: product.price,
        quantity: 1,
        imageUrl: product.imageUrl,
      ));
    }
    notifyListeners();
  }

  void removeItem(String name) {
    _items.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  void updateQuantity(String name, int quantity) {
    if (quantity <= 0) {
      removeItem(name);
      return;
    }
    
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
