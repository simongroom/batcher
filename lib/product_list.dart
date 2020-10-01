import 'package:batcher/product_detail.dart';
import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future getProductList() async {
    return products.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: getProductList(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong");
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
                          builder: (context) => ProductDetail(
                            product: product,
                          ),
                        ),
                      );
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
                print("add clicked");
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
