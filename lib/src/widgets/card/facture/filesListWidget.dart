import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FilesListPage extends StatelessWidget {
  final List<Map<String, dynamic>> files; 

  const FilesListPage({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes fichiers')),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: Text(file['nom']),
            subtitle: Text(file['mime_type']),
            onTap: () {
              final pdfUrl = file['signedUrl'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: Text(file['nom'])),
                    body: SfPdfViewer.network(pdfUrl),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
