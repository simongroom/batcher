import 'package:batcher/batch_detail.dart';
import 'package:batcher/models/batch.dart';
import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatchList extends StatefulWidget {
  @override
  _BatchListState createState() => _BatchListState();
}

class _BatchListState extends State<BatchList> {
  final CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future _getDataFuture;
  List<String> productIds = [];
  List<Product> products = [];

  @override
  void initState() {
    _getDataFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDataFuture,
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
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                "No Incomplete Batches",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return Scaffold(
            body: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Batch batch = Batch.fromJson(snapshot.data.docs[index].data());
                Product product = products.firstWhere(
                    (element) => element.productId == batch.productId);
                return Card(
                  child: InkWell(
                    onTap: () {
                      navigateToBatch(context, batch, product);
                    },
                    splashColor: Colors.blue.withAlpha(30),
                    child: ListTile(
                      leading: Text(formatTimeStampToDateString(batch.date)),
                      title: Text(
                          "${product.clientName} | ${product.productName}"),
                      subtitle: Text("Batch: ${batch.batchCode}"),
                      trailing: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
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

  Future getData() async {
    return getBatchList().then((snapshot) async {
      snapshot.docs.forEach((doc) {
        productIds.add(doc.data()['product_id']);
      });
      if (productIds.length > 0) {
        var _productsDoc = await getProductList();
        _productsDoc.docs.forEach((product) {
          products.add(Product.fromJson(product.data()));
        });
      }
      return snapshot;
    });
  }

  Future getBatchList() async {
    return batches
        .where(
          'is_complete',
          isEqualTo: false,
        )
        .orderBy('date', descending: true)
        .get();
  }

  Future getProductList() async {
    return productsCollection
        .where(
          'product_id',
          whereIn: productIds,
        )
        .get();
  }

  void navigateToBatch(
      BuildContext context, Batch batch, Product product) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchDetail(
          batch: batch,
          product: product,
        ),
      ),
    ).then((value) {
      setState(() {
        _getDataFuture = getData();
      });
    });
  }

  String formatTimeStampToDateString(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
