import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Program extends StatelessWidget {
  final String pdfPath = 'prog.pdf'; // Replace with your PDF path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer - First Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: PDFView(
          filePath: pdfPath,
          enableSwipe: false,
          swipeHorizontal: false,
          autoSpacing: false,
          pageSnap: false,
          defaultPage: 0, // Open the PDF at the first page
          onPageChanged: (page, total) {
            print('page change: $page/$total');
          },
          onRender: (_pages) {
            print('PDF rendered, total pages: $_pages');
          },
          onError: (error) {
            print('Error: $error');
          },
        ),
      ),
    );
  }
}
