import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
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
            leading: Icon(Icons.shop),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
        Divider(),
        ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
             onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              },
            ),
        Divider(),
        ListTile(
            title: Text('Manage Priduct'),
            leading: Icon(Icons.edit),
            onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            ),
        Divider(),
        ListTile(
          title: Text('Logout'),
          leading: Icon(Icons.logout),
          onTap: () {
            Navigator.of(context)
                .pop();
           Navigator.of(context).pushReplacementNamed('/');

            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ]),
    );
  }
}
