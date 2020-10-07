import 'package:batcher/batch_detail.dart';
import 'package:batcher/models/batch.dart';
import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductBatches extends StatefulWidget {
  final Product product;

  ProductBatches({
    this.product,
  });

  @override
  _ProductBatchesState createState() => _ProductBatchesState(
        product: product,
      );
}

class _ProductBatchesState extends State<ProductBatches> {
  final Product product;
  final CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');

  Future _getBatchListFuture;
  List<Batch> _batches = [];

  _ProductBatchesState({
    @required this.product,
  });

  @override
  void initState() {
    _getBatchListFuture = getBatchList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getBatchListFuture,
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
                Batch batch = Batch.fromJson(snapshot.data.docs[index].data());
                _batches.add(batch);
                return Card(
                  child: InkWell(
                    onTap: () {
                      navigateToBatch(context, batch);
                    },
                    splashColor: Colors.blue.withAlpha(30),
                    child: ListTile(
                      leading: Text(formatTimeStampToDateString(batch.date)),
                      title: Text(
                          "Batch: ${batch.buildBatchCode(product.productCode)}"),
                      subtitle:
                          Text("Unit Count: ${batch.unitCount.toString()}"),
                      trailing: Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ),
                );
              },
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

  Future getBatchList() async {
    return batches
        .where(
          'product_id',
          isEqualTo: product.productId,
        )
        .orderBy('date', descending: true)
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
    ).then((value) {
      setState(() {
        _getBatchListFuture = getBatchList();
      });
    });
  }

  void newBatchClickHandler(BuildContext context) {
    Batch _lastBatch;
    if (_batches.length > 0) {
      _lastBatch = _batches.reduce((curr, next) {
        if (next == null) {
          return curr;
        } else {
          if (curr.batchNumber > next.batchNumber) {
            return curr;
          } else {
            return next;
          }
        }
      });
    }
    Batch _batch = Batch(
      productId: product.productId,
      date: Timestamp.now(),
    );
    if (_lastBatch != null) {
      _batch.batchNumber = _lastBatch.batchNumber + 1;
    } else {
      _batch.batchNumber = 1;
    }
    navigateToBatch(context, _batch);
  }

  String formatTimeStampToDateString(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
