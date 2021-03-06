import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share/share.dart';

class PdfViewer extends StatelessWidget {
  final String path;
  const PdfViewer({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("Batch PDF"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Share.shareFiles([path], text: 'Batch PDF');
            },
            child: Icon(
              Icons.share,
            ),
          )
        ],
      ),
      path: path,
    );
  }
}
