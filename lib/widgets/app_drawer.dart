import 'package:flutter/material.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Happy Shopping'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
            title: Text('SHOP'),
            leading: IconButton(
              icon: Icon(Icons.shop),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            )),
        Divider(),
        ListTile(
            title: Text('Orders'),
            leading: IconButton(
              icon: Icon(Icons.payment),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              },
            )),
        Divider(),
        ListTile(
            title: Text('Manage Priduct'),
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            )),
      ]),
    );
  }
}
