import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail({
    this.product,
  });

  @override
  _ProductDetailState createState() => _ProductDetailState(
        product: product,
      );
}

class _ProductDetailState extends State<ProductDetail> {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  final Product product;

  _ProductDetailState({
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: product.clientName,
              onChanged: (val) {
                product.clientName = val;
              },
              decoration: const InputDecoration(
                labelText: 'Client Name',
                hintText: 'Client Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the client name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              initialValue: product.productName,
              onChanged: (val) {
                product.productName = val;
              },
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Product Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the product name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: product.productCode.toString(),
              onChanged: (val) {
                product.productCode = int.parse(val);
              },
              decoration: const InputDecoration(
                labelText: 'Product Code',
                hintText: 'Product Code',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the product code';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: product.shelfLife.toString(),
              onChanged: (val) {
                product.shelfLife = int.parse(val);
              },
              decoration: const InputDecoration(
                labelText: 'Shelf Life (months)',
                hintText: 'Shelf Life (months)',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the shelf life';
                }
                return null;
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Cold Fill'),
            value: product.isColdFill,
            onChanged: (bool value) {
              setState(() {
                product.isColdFill = value;
              });
            },
            secondary: const Icon(Icons.thermostat_sharp),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save",
        onPressed: () {
          setState(() {
            if (product.productId == null) {
              // this is a new product, create an id
              product.productId = Uuid().v4();
            }
            products.doc(product.productId).set(product.toJson());
          });
        },
        child: Icon(
          Icons.save,
        ),
      ),
    );
  }
}
