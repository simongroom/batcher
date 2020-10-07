import 'package:batcher/models/product.dart';
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

  Future _getProductListFuture;

  @override
  void initState() {
    _getProductListFuture = getProductList();
    super.initState();
  }

  Future getProductList() async {
    return products.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: _getProductListFuture,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Error Ocurred",
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Something went wrong",
                      style: TextStyle(fontSize: 32.0, color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(snapshot.error.toString()),
                  ),
                ],
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Product product =
                    Product.fromJson(snapshot.data.docs[index].data());
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductView(
                            product: product,
                          ),
                        ),
                      ).then((value) {
                        setState(() {
                          _getProductListFuture = getProductList();
                        });
                      });
                    },
                    splashColor: Colors.blue.withAlpha(30),
                    child: ListTile(
                      title: Text(product.productName),
                      subtitle: Text(product.clientName),
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
                  productName: "New Product",
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
                    _getProductListFuture = getProductList();
                  });
                });
              },
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
