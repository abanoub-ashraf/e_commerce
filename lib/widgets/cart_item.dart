import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
      {Key? key,
      required this.id,
      required this.price,
      required this.quantity,
      required this.title,
      required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).errorColor,
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
          padding: const EdgeInsets.only(right: 15),
          child: const Icon(Icons.delete, color: Colors.white, size: 40),
          alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).remoteItem(productId);
        },
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Are you Sure?"),
              content:
                  const Text("Do you want to remote the item from the Cart?"),
              actions: [
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('₹ $price'),
                )),
              ),
              title: Text(title),
              subtitle: Text("Total ₹ ${price * quantity}"),
              trailing: Text("x $quantity"),
            ),
          ),
        ),
      ),
    );
  }
}
