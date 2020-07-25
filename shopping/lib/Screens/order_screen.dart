import 'package:flutter/material.dart';
import '../Providers/orders.dart' show Order;
import '../Widgets/order_item.dart';
import 'package:provider/provider.dart';
import '../Widgets/appDrawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orderd';

  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).FetchandSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return AlertDialog(
                title: Text('An error occured'),
                content: Text('Something went wrong '),
                actions: <Widget>[
                  FlatButton(
                    child: Text('okay'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(OrderScreen.routeName);
                    },
                  )
                ],
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.order.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.order[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
