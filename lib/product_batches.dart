import 'package:batcher/batch_detail.dart';
import 'package:batcher/models/batch.dart';
import 'package:batcher/models/product.dart';
import 'package:batcher/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductBatches extends StatefulWidget {
  final Product product;
  final Client client;

  ProductBatches({
    @required this.product,
    @required this.client,
  });

  @override
  _ProductBatchesState createState() => _ProductBatchesState(
        product: product,
        client: client,
      );
}

class _ProductBatchesState extends State<ProductBatches> {
  final Product product;
  final Client client;
  final CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');

  Future _getBatchListFuture;
  List<Batch> _batches = [];

  _ProductBatchesState({
    @required this.product,
    @required this.client,
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
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Delete Batch",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Delete Batch",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _batches.removeWhere((e) => e.batchId == batch.batchId);
                    batch.delete().then((value) {
                      setState(() {
                        _getBatchListFuture = getBatchList();
                      });
                    });
                  },
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        navigateToBatch(context, batch);
                      },
                      splashColor: Colors.blue.withAlpha(30),
                      child: ListTile(
                        leading: Text(formatTimeStampToDateString(batch.date)),
                        title: Text("Batch: ${batch.batchCode}"),
                        subtitle: Text(
                            "Unit Count: ${batch.unitCount.toString()} | Half Gallon Count: ${batch.halfGallonCount.toString()} | Gallon Count: ${batch.gallonCount.toString()} | Pail Count: ${batch.pailCount.toString()} | Packet Count: ${batch.packetCount.toString()}"),
                        trailing: batch.isComplete(product.isColdFill)
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
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
          product: product,
          client: client,
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
    int _nextBatchNumber;
    if (product.nextBatchNumber != null) {
      _nextBatchNumber = product.nextBatchNumber;
    } else {
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
    }
    Batch _batch = Batch(
      productId: product.productId,
      date: Timestamp.now(),
    );
    if (_nextBatchNumber == null) {
      if (_lastBatch != null) {
        _nextBatchNumber = _lastBatch.batchNumber + 1;
      } else {
        _nextBatchNumber = 1;
      }
    }
    _batch.batchNumber = _nextBatchNumber;
    product.nextBatchNumber = null;
    _batch.batchCode = buildBatchCode(
        _batch.batchNumber, product.productCode, product.reverseBatchCode);
    navigateToBatch(context, _batch);
  }

  String buildBatchCode(
      int batchNumber, int productCode, bool reverseBatchCode) {
    String batchCodeString = convertIntToString(batchNumber);
    String productCodeString = convertIntToString(productCode);
    return reverseBatchCode
        ? "$productCodeString-$batchCodeString"
        : "$batchCodeString-$productCodeString";
  }

  String convertIntToString(int i) {
    String s = i.toString();
    if (i < 10) {
      s = "0" + i.toString();
    }
    return s;
  }

  String formatTimeStampToDateString(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
