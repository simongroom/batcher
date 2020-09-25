import 'package:batcher/product_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batcher"),
      ),
      body: ProductList(),
    );
  }
}
