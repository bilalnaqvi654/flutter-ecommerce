import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFav;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      this.isFav = false,
      @required this.price});
  void _setValue(bool newValue) {
    isFav = newValue;
  }

  Future<void> isfavrouteToggle(String AuthToken) async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();

    final url =
        'https://my-shopp-a942f.firebaseio.com/products/$id.json?auth=$AuthToken';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavrioute': isFav,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setValue(oldStatus);
      }
    } catch (error) {
      _setValue(oldStatus);
    }
  }
}
