import 'package:batcher/models/product.dart';
import 'package:batcher/product_batches.dart';
import 'package:batcher/product_detail.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  final Product product;

  ProductView({
    this.product,
  });

  @override
  _ProductViewState createState() => _ProductViewState(
        product: product,
      );
}

class _ProductViewState extends State<ProductView> {
  int _currentIndex = 0;
  final Product product;
  final List<Widget> _children = [];

  _ProductViewState({
    @required this.product,
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
