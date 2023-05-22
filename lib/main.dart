import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  String output = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: widget._messangerKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('PDF to Notes')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            primary: false,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (output.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: output));
                        widget._messangerKey.currentState!.showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      child: const Text('Copy Output'),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      // pick a PDF file
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null) {
                        // load the selected PDF document
                        final PdfDocument document = PdfDocument(inputBytes: result.files.first.bytes);
                        // create PDF text extractor to extract text
                        final PdfTextExtractor extractor = PdfTextExtractor(document);
                        // extract text from the first page of the document
                        final String text = extractor.extractText(startPageIndex: 0, endPageIndex: document.pages.count - 1, layoutText: true);

                        // print the extracted text
                        setState((){
                          output = text;
                        });
                      }
                    },
                    child: Text(output.isEmpty ? 'Select a PDF file' : 'Select a new PDF file'),
                  ),
                ],
              ),
              Text(output),
            ],
          ),
        ),
      ),
    );
  }
}
