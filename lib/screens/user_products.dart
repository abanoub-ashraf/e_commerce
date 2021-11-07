import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user_products';

  const UserProducts({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProductions(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Products"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName);
              },
            )
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: (ctx, productsdata, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              children: [
                                UserProductItem(
                                  imageUrl: productsdata.items[index].imageUrl,
                                  title: productsdata.items[index].title,
                                  id: productsdata.items[index].id,
                                ),
                                const Divider()
                              ],
                            ),
                            itemCount: productsdata.items.length,
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
