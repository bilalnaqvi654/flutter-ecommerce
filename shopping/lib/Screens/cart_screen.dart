import 'package:flutter/material.dart';
import '../Providers/cart.dart';
import '../Providers/orders.dart';
import 'package:provider/provider.dart';
import '../Widgets/cart_item.dart' as ci;
import '../Screens/order_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var children2 = <Widget>[
      Text(
        'Total',
        style: TextStyle(fontSize: 20),
      ),
      Spacer(),
      Chip(
        label: Text(
          '\$${cart.total_amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      OrderButton(cart: cart),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Cart',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children2,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => ci.CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title),
              ),
            )
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.total_amount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });

              await Provider.of<Order>(context).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.total_amount,
              );
              setState(() {
                _isloading = false;
              });
              widget.cart.clear();
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
      child: Text(
        'Order Now',
      ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
