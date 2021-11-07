import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartitem) => CartItem(
              id: existingCartitem.id,
              title: existingCartitem.title,
              quantity: existingCartitem.quantity + 1,
              price: existingCartitem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () =>
              CartItem(id: productId, price: price, quantity: 1, title: title));
    }
    notifyListeners();
  }

  void remoteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if ((_items[productId]?.quantity ?? 0) > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity,
            title: existingCartItem.title),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
