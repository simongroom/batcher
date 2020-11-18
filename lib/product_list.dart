import 'package:batcher/models/product.dart';
import 'package:batcher/models/client.dart';
import 'package:batcher/product_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final Client client;

  const ProductList({Key key, this.client}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState(client);
}

class _ProductListState extends State<ProductList> {
  final Client client;

  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  List<Product> productList = [];

  _ProductListState(
    this.client,
  );

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  void getProductList() async {
    QuerySnapshot _products =
        await products.where("client_id", isEqualTo: client.clientId).get();
    setState(() {
      productList = _products.docs.map((p) {
        return Product.fromJson(p.data());
      }).toList();
      productList.sort((a, b) => a.productName.compareTo(b.productName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.clientName),
      ),
      body: productList.length == 0
          ? Center(
              child: Text(
                "No Products - tap the + button to add one",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
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
                            client: client,
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
                      title: Text(productList[index].productName),
                      // subtitle: ,
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
                client: client,
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
