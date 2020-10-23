import 'package:batcher/models/product.dart';
import 'package:batcher/product_search.dart';
import 'package:batcher/product_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  List<Product> productList = [];

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  void getProductList() async {
    QuerySnapshot _products = await products.get();
    setState(() {
      productList = _products.docs.map((p) {
        return Product.fromJson(p.data());
      }).toList();
      productList.sort((a, b) => a.clientName.compareTo(b.clientName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ProductSearch(
                    productList: productList,
                  ));
            },
            icon: Icon(Icons.search),
          )
        ],
        title: Text('Search Products'),
        backgroundColor: Colors.grey[400],
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductView(
                      product: productList[index],
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    getProductList();
                  });
                });
              },
              splashColor: Colors.blue.withAlpha(30),
              child: ListTile(
                title: Text(productList[index].clientName),
                subtitle: Text(productList[index].productName),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Product",
        child: Icon(Icons.add),
        onPressed: () {
          Product _product = Product(
            productName: "",
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                product: _product,
              ),
            ),
          ).then((value) {
            setState(() {
              getProductList();
            });
          });
        },
      ),
    );
  }
}
