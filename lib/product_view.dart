import 'package:batcher/models/product.dart';
import 'package:batcher/models/client.dart';
import 'package:batcher/product_batches.dart';
import 'package:batcher/product_detail.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  final Product product;
  final Client client;

  ProductView({
    @required this.product,
    @required this.client,
  });

  @override
  _ProductViewState createState() => _ProductViewState(
        product: product,
        client: client,
      );
}

class _ProductViewState extends State<ProductView> {
  int _currentIndex = 0;
  final Product product;
  final Client client;
  final List<Widget> _children = [];

  _ProductViewState({
    @required this.product,
    @required this.client,
  });

  void onTabTapped(int index) {
    if (index == 1 && product.productId == null) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _children.add(ProductDetail(
      product: product,
    ));
    _children.add(ProductBatches(
      product: product,
      client: client,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Batches',
          )
        ],
      ),
    );
  }
}
