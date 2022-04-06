import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlControler = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(description: '', id: null, imageUrl: '', price: 0, title: '');
  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };
  var _isInit = true;
  var _isLodding = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'imageUrl': '',
          'price': _editProduct.price.toString(),
        };
        _imageUrlControler.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlControler.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlControler.text.startsWith('http') &&
              !_imageUrlControler.text.startsWith('https')) ||
          (!_imageUrlControler.text.endsWith('.png') &&
              !_imageUrlControler.text.endsWith('.jpg') &&
              !_imageUrlControler.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLodding = true;
    });
    if (_editProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updatesProduct(_editProduct.id!, _editProduct);
      setState(() {
        _isLodding = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An eerror Occurred!'),
            content: Text('Something went Wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okey'))
            ],
          ),
        );
      } finally {
        setState(() {
          _isLodding = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLodding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Value';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              description: _editProduct.description,
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              imageUrl: _editProduct.imageUrl,
                              price: _editProduct.price,
                              title: value!);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter Valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please Enter value grater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              description: _editProduct.description,
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              imageUrl: _editProduct.imageUrl,
                              price: double.parse(value!),
                              title: _editProduct.title);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Description';
                          }
                          if (value.length < 10) {
                            return 'Please Enter at least 10 charactera long';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              description: value!,
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              imageUrl: _editProduct.imageUrl,
                              price: _editProduct.price,
                              title: _editProduct.title);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            )),
                            child: _imageUrlControler.text.isEmpty
                                ? Text('Enter a Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlControler.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocusNode,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlControler,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editProduct = Product(
                                    description: _editProduct.description,
                                    id: _editProduct.id,
                                    isFavorite: _editProduct.isFavorite,
                                    imageUrl: value!,
                                    price: _editProduct.price,
                                    title: _editProduct.title);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please Enter Valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please Enter valid Image URL';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
