import 'package:flutter/cupertino.dart';
import 'package:shopping/Providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  final String authToken;
  final String userId;

  Order(this.authToken, this.userId, this._order);
  List<OrderItem> get order {
    return _order;
  }

  Future<void> FetchandSetOrders() async {
    final url =
        'https://my-shopp-a942f.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> _loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      _loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['Date and Time']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _order = _loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    final url =
        'https://my-shopp-a942f.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'Date and Time': timestamp.toIso8601String(),
          'products': cartproducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _order.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartproducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }
}
