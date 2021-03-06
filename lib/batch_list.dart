import 'package:batcher/batch_detail.dart';
import 'package:batcher/models/batch.dart';
import 'package:batcher/models/product.dart';
import 'package:batcher/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum BatchListType {
  incomplete,
  unbilled,
}

class BatchList extends StatefulWidget {
  final BatchListType listType;

  BatchList(
    Key key,
    this.listType,
  ) : super(key: key);

  @override
  _BatchListState createState() => _BatchListState(listType);
}

class _BatchListState extends State<BatchList> {
  final BatchListType listType;

  _BatchListState(
    this.listType,
  );

  final CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');

  Future _getDataFuture;
  List<String> productIds = [];
  List<String> clientIds = [];
  List<Product> products = [];
  List<Client> clients = [];

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
                listType == BatchListType.incomplete
                    ? "No Incomplete Batches"
                    : "No Unbilled Batches",
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
                Client client = clients.firstWhere(
                    (element) => element.clientId == product.clientId);
                return Card(
                  child: InkWell(
                    onTap: () {
                      navigateToBatch(context, batch, product, client);
                    },
                    splashColor: Colors.blue.withAlpha(30),
                    child: ListTile(
                      leading: Text(formatTimeStampToDateString(batch.date)),
                      title:
                          Text("${client.clientName} | ${product.productName}"),
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
        String productId = doc.data()['product_id'];
        if (productIds.indexOf(productId) == -1) {
          productIds.add(doc.data()['product_id']);
        }
      });
      if (productIds.length > 0) {
        await getProductList();
        await getClientList();
      }
      return snapshot;
    });
  }

  Future getBatchList() async {
    String whereClause =
        listType == BatchListType.unbilled ? 'billing_complete' : 'is_complete';
    Query query = batches.where(
      whereClause,
      isEqualTo: false,
    );
    return query.orderBy('date', descending: true).get();
  }

  Future processProductIdChunk(productIdChunk) async {
    var _productsDoc = await productsCollection
        .where(
          'product_id',
          whereIn: productIdChunk,
        )
        .get();
    _productsDoc.docs.forEach((product) {
      products.add(Product.fromJson(product.data()));
    });
    products.forEach((Product product) {
      if (clientIds.indexOf(product.clientId) == -1) {
        clientIds.add(product.clientId);
      }
    });
    return;
  }

  Future processClientIdChunk(clientIdChunk) async {
    var _clientsDoc = await clientsCollection
        .where(
          'client_id',
          whereIn: clientIdChunk,
        )
        .get();
    _clientsDoc.docs.forEach((client) {
      clients.add(Client.fromJson(client.data()));
    });
  }

  Future processIdChunks(idList, chunkCallback) async {
    var chunks = chunkList(idList);
    var futures = <Future>[];
    for (var idChunk in chunks) {
      futures.add(chunkCallback(idChunk));
    }
    await Future.wait(futures);
  }

  Future getProductList() async {
    await processIdChunks(productIds, processProductIdChunk);
  }

  Future getClientList() async {
    await processIdChunks(clientIds, processClientIdChunk);
  }

  void navigateToBatch(
    BuildContext context,
    Batch batch,
    Product product,
    Client client,
  ) async {
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
        _getDataFuture = getData();
      });
    });
  }

  String formatTimeStampToDateString(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List chunkList(listToChunk) {
    var len = listToChunk.length;
    var size = 10;
    var chunks = [];
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      chunks.add(listToChunk.sublist(i, end));
    }
    return chunks;
  }
}
