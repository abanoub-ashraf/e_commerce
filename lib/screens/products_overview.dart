import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverview extends StatefulWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var _isinit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProductions();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProductions().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                  child: Text("One Favorites"), value: FilterOptions.favorites),
              const PopupMenuItem(
                  child: Text("Show All"), value: FilterOptions.all),
            ],
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedView) {
              setState(() {
                if (selectedView == FilterOptions.favorites) {
                  // productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch as Widget, value: cart.itemCount.toString()),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart)),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
