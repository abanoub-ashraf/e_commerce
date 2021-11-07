import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    "₹${cart.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1
                            ?.color),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                OrderButton(cart: cart),
              ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int i) => CartItem(
              productId: cart.items.keys.toList()[i],
              id: cart.items.values.toList()[i].id,
              price: cart.items.values.toList()[i].price,
              quantity: cart.items.values.toList()[i].quantity,
              title: cart.items.values.toList()[i].title,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clear();
                setState(() {
                  _isLoading = false;
                });
              },
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text("Order Now", style: TextStyle(fontSize: 20)));
  }
}
