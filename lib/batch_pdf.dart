import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:batcher/models/batch.dart';
import 'package:batcher/models/product.dart';
import 'package:batcher/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as widgets;
import 'package:universal_html/html.dart' as html;

reportView(BuildContext context, Batch batch, Product product) async {
  final widgets.Document pdf = widgets.Document();

  pdf.addPage(
    widgets.Page(
      pageFormat: PdfPageFormat.a4,
      build: (widgets.Context context) {
        return widgets.Column(
          children: [
            widgets.Header(
              level: 2,
              child: widgets.Center(
                child: widgets.Text(
                    '${product.clientName} - ${product.productName}',
                    style: widgets.TextStyle(
                      fontSize: 16,
                      fontWeight: widgets.FontWeight.bold,
                    )),
              ),
            ),
            widgets.Header(
              child: widgets.Align(
                alignment: widgets.Alignment.center,
                child: widgets.Text(
                  'Batch: ${batch.buildBatchCode(product.productCode)}',
                  style: widgets.TextStyle(
                    fontSize: 36,
                    fontWeight: widgets.FontWeight.bold,
                  ),
                ),
              ),
            ),
            widgets.Column(
              children: [
                widgets.Padding(
                  padding: widgets.EdgeInsets.all(8.0),
                  child: widgets.Row(
                    mainAxisAlignment: widgets.MainAxisAlignment.spaceEvenly,
                    children: [
                      widgets.Text("Batch Date"),
                      widgets.Text(DateFormat("yyyy-MM-dd")
                          .format(batch.date.toDate())
                          .toString()),
                    ],
                  ),
                ),
                widgets.Padding(
                  padding: widgets.EdgeInsets.all(8.0),
                  child: widgets.Table.fromTextArray(
                    context: context,
                    data: <List<String>>[
                      <String>[
                        'Unit Count',
                        'Half Gallon Count',
                        'Gallon Count',
                        'Pail Count',
                      ],
                      <String>[
                        batch.unitCount.toString(),
                        batch.halfGallonCount.toString(),
                        batch.gallonCount.toString(),
                        batch.pailCount.toString(),
                      ],
                    ],
                    cellAlignment: widgets.Alignment.center,
                  ),
                ),
                product.isColdFill
                    ? widgets.Padding(
                        padding: widgets.EdgeInsets.all(8.0),
                        child: widgets.Row(
                          mainAxisAlignment:
                              widgets.MainAxisAlignment.spaceBetween,
                          children: [
                            widgets.Text("ph Prior"),
                            widgets.Text(
                              batch.phPrior == null
                                  ? batch.phPrior.toString()
                                  : "Incomplete",
                              style: widgets.TextStyle(
                                color: PdfColors.red,
                                fontWeight: widgets.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : widgets.Container(),
                widgets.Padding(
                  padding: widgets.EdgeInsets.all(8.0),
                  child: widgets.Row(
                    mainAxisAlignment: widgets.MainAxisAlignment.spaceBetween,
                    children: [
                      widgets.Text("ph Post"),
                      batch.phPost == null
                          ? widgets.Text(
                              "Incomplete",
                              style: widgets.TextStyle(
                                color: PdfColors.red,
                                fontWeight: widgets.FontWeight.bold,
                              ),
                            )
                          : widgets.Text(
                              batch.phPost.toString(),
                            ),
                    ],
                  ),
                ),
                product.isColdFill
                    ? widgets.Container()
                    : widgets.Padding(
                        padding: widgets.EdgeInsets.all(8.0),
                        child: widgets.Row(
                          mainAxisAlignment:
                              widgets.MainAxisAlignment.spaceBetween,
                          children: [
                            widgets.Text("Hot Fill Temp"),
                            batch.hotFillTemp != null
                                ? widgets.Text(batch.hotFillTemp.toString())
                                : widgets.Text(
                                    "Incomplete",
                                    style: widgets.TextStyle(
                                      color: PdfColors.red,
                                      fontWeight: widgets.FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                product.isColdFill
                    ? widgets.Container()
                    : widgets.Padding(
                        padding: widgets.EdgeInsets.all(8.0),
                        child: widgets.Row(
                          mainAxisAlignment:
                              widgets.MainAxisAlignment.spaceBetween,
                          children: [
                            widgets.Text("Cook To Temp"),
                            batch.cookToTemp
                                ? widgets.Text(
                                    "Complete",
                                    style: widgets.TextStyle(
                                      color: PdfColors.green,
                                      fontWeight: widgets.FontWeight.bold,
                                    ),
                                  )
                                : widgets.Text(
                                    "Incomplete",
                                    style: widgets.TextStyle(
                                      color: PdfColors.red,
                                      fontWeight: widgets.FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                widgets.Padding(
                  padding: widgets.EdgeInsets.all(8.0),
                  child: widgets.Row(
                    mainAxisAlignment: widgets.MainAxisAlignment.spaceBetween,
                    children: [
                      widgets.Text("Lid Check"),
                      batch.lidCheck
                          ? widgets.Text(
                              "Complete",
                              style: widgets.TextStyle(
                                color: PdfColors.green,
                                fontWeight: widgets.FontWeight.bold,
                              ),
                            )
                          : widgets.Text(
                              "Incomplete",
                              style: widgets.TextStyle(
                                color: PdfColors.red,
                                fontWeight: widgets.FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
                widgets.Padding(
                  padding: widgets.EdgeInsets.all(8.0),
                  child: widgets.Row(
                    mainAxisAlignment: widgets.MainAxisAlignment.spaceBetween,
                    children: [
                      widgets.Text("Ingredients Verified"),
                      batch.ingredientsVerified
                          ? widgets.Text(
                              "Complete",
                              style: widgets.TextStyle(
                                color: PdfColors.green,
                                fontWeight: widgets.FontWeight.bold,
                              ),
                            )
                          : widgets.Text(
                              "Incomplete",
                              style: widgets.TextStyle(
                                color: PdfColors.red,
                                fontWeight: widgets.FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
                widgets.Container(
                  decoration: widgets.BoxDecoration(
                    border: widgets.BoxBorder(
                      top: true,
                    ),
                  ),
                  child: widgets.Padding(
                    padding: widgets.EdgeInsets.all(8.0),
                    child: widgets.Align(
                        child: widgets.Text("Notes"),
                        alignment: widgets.Alignment.centerLeft),
                  ),
                ),
                widgets.Padding(
                  padding: widgets.EdgeInsets.all(8.0),
                  child: batch.notes == null
                      ? widgets.Text(
                          "No Notes entered",
                        )
                      : widgets.Text(
                          batch.notes,
                        ),
                ),
                batch.initials == null
                    ? widgets.Container()
                    : widgets.Container(
                        decoration: widgets.BoxDecoration(
                          border: widgets.BoxBorder(
                            top: true,
                          ),
                        ),
                        child: widgets.Padding(
                          padding: widgets.EdgeInsets.all(8.0),
                          child: widgets.Footer(
                            leading: widgets.Text("Completed By: "),
                            title: widgets.Text(
                              batch.initials,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ); // Center
      },
    ),
  );

  if (kIsWeb) {
    // running on the web!
    final bytes = pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
    html.Url.revokeObjectUrl(url);
  } else {
    // NOT running on the web!
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/batch_pdf.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewer(path: path),
      ),
    );
  }
}
