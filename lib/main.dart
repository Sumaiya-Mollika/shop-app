import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/provider/product_provider.dart';

import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/product_details_screen.dart';
import 'package:shop_app/screen/product_overview_screen.dart';
import 'package:shop_app/screen/splash_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', '', []),
            update: (_, auth, previousProducts) => Products(
              auth.token!,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (_) => Order('', '', []),
            update: (_, auth, previousOrders) => Order(
              auth.token!,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  primary: Colors.purple,
                  seedColor: Colors.transparent,
                  secondary: Colors.deepOrange),
            ),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
