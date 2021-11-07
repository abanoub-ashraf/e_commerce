import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/order_screen";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(
              child: Text("An error Occurred!"),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemBuilder: (ctx, i) => OrderItem(orderData.order[i]),
                itemCount: orderData.order.length,
              ),
            );
          }
        },
      ),
    );
  }
}
