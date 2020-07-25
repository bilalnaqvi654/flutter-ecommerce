import 'package:flutter/material.dart';
import '../Screens/order_screen.dart';
import '../Screens/user_products_screen.dart';
import '../Providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.shop,
              ),
              title: Text('My Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.edit,
              ),
              title: Text('Manage Your Produts'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('My Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context).logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
