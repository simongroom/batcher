import 'package:batcher/batch_detail.dart';
import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/batch.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  final CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');

  ProductDetail({
    this.product,
  });

  String formatTimeStampToDateString(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future getBatchList() async {
    return batches
        .where(
          'product_id',
          isEqualTo: product.productId,
        )
        .get();
  }

  void navigateToBatch(BuildContext context, Batch batch) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchDetail(
          batch: batch,
          productCode: product.productCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: getBatchList(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(product.productName),
            ),
            body: Column(
              children: [
                Text(
                    "Product Code: ${convertIntToString(product.productCode)}"),
                Text("Shelf Life: ${product.shelfLife.toString()} months"),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Batch batch =
                          Batch.fromJson(snapshot.data.docs[index].data());
                      return Card(
                        child: InkWell(
                          onTap: () {
                            navigateToBatch(context, batch);
                          },
                          splashColor: Colors.blue.withAlpha(30),
                          child: ListTile(
                            leading:
                                Text(formatTimeStampToDateString(batch.date)),
                            title:
                                Text(batch.buildBatchCode(product.productCode)),
                            subtitle: Text(
                                "Unit Count: ${batch.unitCount.toString()}"),
                            trailing: Icon(
                              Icons.arrow_forward,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: "New Batch",
              child: Icon(Icons.add),
              onPressed: () {
                newBatchClickHandler(context);
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

  String convertIntToString(int i) {
    String s = i.toString();
    if (i < 10) {
      s = "0" + i.toString();
    }
    return s;
  }

  void newBatchClickHandler(BuildContext context) {
    Batch _batch = Batch(
      productId: product.productId,
      date: Timestamp.now(),
    );
    navigateToBatch(context, _batch);
  }
}
