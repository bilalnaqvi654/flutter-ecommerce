import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/products_grid.dart';
import '../Providers/cart.dart';
import '../Widgets/batch.dart';
import './cart_screen.dart';
import '../Widgets/appDrawer.dart';
import '../Providers/Products.dart';

enum filteroptions {
  Favroutes,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showonlyfaves = false;
  var _init = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).getProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShopp'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filteroptions SelectedValue) {
              setState(() {
                if (SelectedValue == filteroptions.Favroutes) {
                  _showonlyfaves = true;
                } else {
                  _showonlyfaves = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favroutes'),
                value: filteroptions.Favroutes,
              ),
              PopupMenuItem(
                child: Text('Show all '),
                value: filteroptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showonlyfaves),
    );
  }
}
