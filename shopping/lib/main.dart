import 'package:flutter/material.dart';
import './Screens/product_overview.dart';
import './Screens/product_detail_screen.dart';
import './Providers/Products.dart';
import './Providers/cart.dart';
import 'package:provider/provider.dart';
import './Screens/cart_screen.dart';
import './Providers/orders.dart';
import './Screens/order_screen.dart';
import './Screens/user_products_screen.dart';
import './Screens/edit_product_screen.dart';
import './Screens/auth_screen.dart';
import './Providers/auth.dart';
import './Screens/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (ctx, auth, previousProduct) => Products(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            builder: (ctx, auth, previousOrder) => Order(
              auth.token,
              auth.userId,
              previousOrder == null ? [] : previousOrder.order,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            // home: auth.isAuth
            //     ? ProductOverviewScreen()
            //     : FutureBuilder(
            //         future: auth.autoLogin(),
            //         builder: (ctx, authResultSnapshots) =>
            //             authResultSnapshots.connectionState ==
            //                     ConnectionState.waiting
            //                 ? SplashScreen()
            //                 : AuthScreen(),
            //       ),
            routes: {
              ProductDetails.routeName: (ctx) => ProductDetails(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
