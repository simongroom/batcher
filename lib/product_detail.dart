import 'package:batcher/models/product.dart';
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
  final Product product;

  _ProductDetailState({
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: product.nextBatchNumber?.toString(),
                onChanged: (val) {
                  product.nextBatchNumber = int.parse(val);
                },
                decoration: const InputDecoration(
                  labelText: 'Next Batch Number',
                  hintText: 'Next Batch Number',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the next batch number';
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
            SwitchListTile(
              title: const Text('Reverse Batch Code'),
              value: product.reverseBatchCode,
              onChanged: (bool value) {
                setState(() {
                  product.reverseBatchCode = value;
                });
              },
              secondary: const Icon(Icons.compare_arrows),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save",
        onPressed: () {
          setState(() {
            if (product.productId == null) {
              // this is a new product, create an id
              product.productId = Uuid().v4();
            }
            product.save();
          });
        },
        child: Icon(
          Icons.save,
        ),
      ),
    );
  }
}
