import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${loadedProduct.price}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            child: Text(
              '${loadedProduct.description}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ]),
      ),
    );
  }
}
