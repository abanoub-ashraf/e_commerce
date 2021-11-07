import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProducts(id);
                } catch (e) {
                  scaffold.showSnackBar(const SnackBar(
                      content: Center(child: Text("Deleting Failed"))));
                }
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .deleteProducts(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
