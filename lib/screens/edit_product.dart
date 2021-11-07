import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = "/edit_product";

  const EditProduct({Key? key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: "", title: "", price: 0, description: "", imageUrl: "");
  var isLoading = false;

  var _isinit = true;
  var _initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": ""
  };

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isinit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findbyId(productId.toString());
        _initValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
          // "imageUrl": _editedProduct.imageUrl Not allowed when you have controller set
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isinit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg") &&
              !_imageUrlController.text.endsWith(".webp"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveFrom() async {
    final isvalid = _form.currentState?.validate();
    if (isvalid != null && !isvalid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _form.currentState?.save();
    if (_editedProduct.id != "") {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An Error Occurred"),
                  content: const Text("Something Went Wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Okay"))
                  ],
                ));
      }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveFrom,
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues["title"],
                      decoration: const InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please Provide a value.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value ?? "",
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["price"],
                      decoration: const InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please Provide a price.";
                        }
                        if (value != null && double.tryParse(value) == null) {
                          return "Please enter a valid number.";
                        }
                        if (value != null && double.parse(value) <= 0) {
                          return "Plase enter a greater than zero number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: double.parse(value ?? "0"),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["description"],
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please Provide a value.";
                        }

                        if (value != null && value.length < 10) {
                          return "Should be at least 10 characters long.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value ?? "",
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text("Enter a URL")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveFrom();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value ?? "",
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
