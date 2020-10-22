import 'package:batcher/batch_pdf.dart';
import 'package:batcher/models/batch.dart';
import 'package:batcher/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BatchDetail extends StatefulWidget {
  final Batch batch;
  final Product product;

  BatchDetail({
    @required this.batch,
    @required this.product,
  });

  @override
  _BatchDetailState createState() => _BatchDetailState(
        batch: batch,
        product: product,
      );
}

class _BatchDetailState extends State<BatchDetail> {
  final _formKey = GlobalKey<FormState>();
  final Batch batch;
  final Product product;

  _BatchDetailState({
    @required this.batch,
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Batch: ${batch.buildBatchCode(product.productCode, product.reverseBatchCode)}",
            ),
            Text('${product.clientName} - ${product.productName}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              reportView(context, batch, product);
            },
            child: Icon(
              Icons.report,
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    initialValue: batch.date.toDate().toString(),
                    onChanged: (val) {
                      DateTime _date = DateTime.parse(val);
                      widget.batch.date = Timestamp.fromDate(_date);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Processing Date',
                      hintText: 'YYYY-mm-dd',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the processing date';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: batch.buildBatchCode(
                        product.productCode, product.reverseBatchCode),
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      batch.batchCode = val;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Batch Code',
                      hintText: 'Batch Code',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the batch code';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: batch.unitCount.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            batch.unitCount = int.parse(val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Unit Count',
                            hintText: 'Unit Count',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the unit count';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: batch.halfGallonCount.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            batch.halfGallonCount = int.parse(val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Half Gallon Count',
                            hintText: 'Half Gallon Count',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the half gallon count';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: batch.gallonCount.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            batch.gallonCount = int.parse(val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Gallon Count',
                            hintText: 'Gallon Count',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Gallon count';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: batch.pailCount.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            batch.pailCount = int.parse(val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Pail Count',
                            hintText: 'Pail Count',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Pail count';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                product.isColdFill
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: batch.hotFillTemp?.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            batch.hotFillTemp = double.parse(val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Hot Fill Temp',
                            hintText: 'Hot Fill Temp',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Hot Fill Temp';
                            }
                            return null;
                          },
                        ),
                      ),
                product.isColdFill
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: batch.phPrior?.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            batch.phPrior = double.parse(val);
                          },
                          decoration: const InputDecoration(
                            labelText: 'ph Prior',
                            hintText: 'ph Prior',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the ph Prior value';
                            }
                            return null;
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: batch.phPost?.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      batch.phPost = double.parse(val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'ph Post',
                      hintText: 'ph Post',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the ph Post value';
                      }
                      return null;
                    },
                  ),
                ),
                product.isColdFill
                    ? Container()
                    : CheckboxListTile(
                        title: Text("Cook To Temp"),
                        value: batch.cookToTemp,
                        onChanged: (newValue) {
                          setState(() {
                            batch.cookToTemp = newValue ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.platform,
                      ),
                CheckboxListTile(
                  title: Text("Lid Check"),
                  value: batch.lidCheck,
                  onChanged: (newValue) {
                    setState(() {
                      batch.lidCheck = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.platform,
                ),
                CheckboxListTile(
                  title: Text("Ingredients Verified"),
                  value: batch.ingredientsVerified,
                  onChanged: (newValue) {
                    setState(() {
                      batch.ingredientsVerified = newValue ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.platform,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: batch.initials,
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      batch.initials = val;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Initials',
                      hintText: 'Initials',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the initials';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: batch.notes,
                    keyboardType: TextInputType.text,
                    onChanged: (val) {
                      batch.notes = val;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Notes',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter any notes';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save",
        onPressed: () {
          if (batch.batchId == null) {
            // this is a new batch, create id
            batch.batchId = Uuid().v4();
          }
          product.save().then(
              (value) => batch.save().then((value) => Navigator.pop(context)));
        },
        child: Icon(
          Icons.save,
        ),
      ),
    );
  }
}
