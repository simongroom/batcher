import 'package:batcher/batch_detail.dart';
import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatchList extends StatelessWidget {
  final Product product;

  BatchList({
    this.product,
  });

  String formatTimeStampToDateString(DateTime date) {
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: Column(
        children: [
          Text("Product Code: ${convertIntToString(product.productCode)}"),
          Text("Shelf Life: ${product.shelfLife.toString()} months"),
          Expanded(
            child: ListView(
              children: getBatchTiles(context),
            ),
          ),
        ],
      ),
    );
  }

  String convertIntToString(int i) {
    String s = i.toString();
    if (i < 10) {
      s = "0" + i.toString();
    }
    return s;
  }

  Text buildBatchCode(int productCode, int batchCode) {
    String batchCodeString = convertIntToString(batchCode);
    String productCodeString = convertIntToString(productCode);
    return Text("Batch: $batchCodeString-$productCodeString");
  }

  List<Widget> getBatchTiles(BuildContext context) {
    return [];
    // return product.batches.map<Widget>((p) {
    //   return Card(
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => BatchDetail(
    //               batch: p,
    //             ),
    //           ),
    //         );
    //       },
    //       splashColor: Colors.blue.withAlpha(30),
    //       child: ListTile(
    //         leading: Text(formatTimeStampToDateString(p.date)),
    //         title: buildBatchCode(product.productCode, p.batchCode),
    //         subtitle: Text("Unit Count: ${p.unitCount.toString()}"),
    //         trailing: Icon(
    //           Icons.arrow_forward,
    //         ),
    //       ),
    //     ),
    //   );
    // }).toList();
  }
}
