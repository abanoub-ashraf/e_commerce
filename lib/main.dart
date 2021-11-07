import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product.dart';
import './screens/orders_screen.dart';
import './screens/products_details.dart';
import './screens/products_overview.dart';
import './screens/splash_screen.dart';
import './screens/user_products.dart';
import 'helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts != null ? [] : previousProducts!.items),
            create: (ctx) => Products("null", "", []),
          ),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders != null ? [] : previousOrders!.order),
            create: (ctx) => Orders("null", "", []),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'State Management',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                fontFamily: "Lato",
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
            home: auth.isAuth
                ? const ProductsOverview()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen()),
            routes: {
              ProductDetails.routeName: (ctx) => const ProductDetails(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProducts.routeName: (ctx) => const UserProducts(),
              EditProduct.routeName: (ctx) => const EditProduct(),
            },
          ),
        ));
  }
}
