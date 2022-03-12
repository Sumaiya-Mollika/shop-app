import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String? productId;
  final String? title;
  final int? quantity;
  final double? price;
  CartItem({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(title!),
            subtitle: Text('Total: \$${(price! * quantity!)}',
                style: TextStyle(color: Colors.white)),
            leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(child: Text('\$$price')),
                )),
            trailing: Text(
              '$quantity x',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
