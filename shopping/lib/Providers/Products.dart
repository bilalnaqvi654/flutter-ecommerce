import 'dart:io';

import 'package:flutter/material.dart';
import '../Providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://aofspades.pk/wp-content/uploads/2019/09/Spades-Designer-Royal-Red-Shirt3.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://www.buyon.pk/image/cache/data/members/tanveer/41cyis5827jl-600x600.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'pan',
    //   description: 'A nice pan .',
    //   price: 59.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/2131/5111/products/carbon-steel-trans_grande.png?v=1588358845',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Mouffler',
    //   description: 'A nice pair of muffler.',
    //   price: 59.99,
    //   imageUrl: 'https://images1.novica.net/pictures/15/p233839_2a_400.jpg',
    // )
  ];

  final String authtoken;
  final String userId;
  Products(this.authtoken, this.userId, this._items);
  List<Product> get items {
    return _items;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get FavItems {
    return items.where((prod) => prod.isFav).toList();
  }

  Future<void> getProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        ('https://my-shopp-a942f.firebaseio.com/products.json?auth=$authtoken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFav: prodData['isFavrioute'],
            title: prodData['title'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        ('https://my-shopp-a942f.firebaseio.com/products.json?auth=$authtoken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'isFavrioute': product.isFav,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://my-shopp-a942f.firebaseio.com/products/$id.json?auth=$authtoken';
      await http.patch(url,
          body: json.encode({
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'title': newProduct.title,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://my-shopp-a942f.firebaseio.com/products/$id.json?auth=$authtoken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.remove(existingProduct);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Something went wrong');
    }
    existingProduct = null;
  }
}
