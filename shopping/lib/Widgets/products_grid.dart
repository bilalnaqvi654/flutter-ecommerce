import 'package:flutter/material.dart';

import '../Widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/Products.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.FavItems : productsData.items;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(

              //  products[i].id,
              //   products[i].title,
              // products[i].imageUrl
              ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
