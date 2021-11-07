import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/products_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showfavorites;
  const ProductsGrid(this.showfavorites, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showfavorites ? productsData.favoriteItem : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) =>
            ChangeNotifierProvider.value(
              value: products[index],
              // create: (ctx) => products[index],

              child: const ProductItem(),
            ));
  }
}
