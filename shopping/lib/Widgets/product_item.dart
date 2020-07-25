import 'package:flutter/material.dart';
import '../Screens/product_detail_screen.dart';
import '../Providers/product.dart';
import '../Providers/cart.dart';
import 'package:provider/provider.dart';
import '../Providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetails.routeName,
            arguments: product.id,
          );
        },
        child: Image.network(product.imageUrl, fit: BoxFit.cover),
      ),
      footer: GridTileBar(
        title: Text(
          product.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
          builder: (ctx, product, _) => IconButton(
            icon: Icon(product.isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.isfavrouteToggle(auth.token);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            cart.additem(
              product.id,
              product.title,
              product.price,
            );
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added Item to Cart',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ),
            );
          },
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
