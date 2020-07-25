import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final int quantity;
  final String title;
  final double price;

  CartItem({
    this.id,
    this.quantity,
    this.title,
    this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return _items;
  }

  void additem(String ProductId, String title, double price) {
    if (_items.containsKey(ProductId)) {
      _items.update(
          ProductId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          ProductId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  double get total_amount {
    var total = 0.0;
    _items.forEach((key, CartItem) {
      total += CartItem.price * CartItem.quantity;
    });
    return total;
  }

  void removeItem(ProductId) {
    _items.remove(ProductId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String ProductId) {
    if (!_items.containsKey(ProductId)) {
      return;
    }
    if (_items[ProductId].quantity > 1) {
      _items.update(
        ProductId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(ProductId);
    }
    notifyListeners();
  }
}
