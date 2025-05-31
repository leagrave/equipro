import 'dart:io';
import 'package:equipro/src/widgets/bottum/bottumAddFileWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserFilesPage extends StatefulWidget {
  final String userId;

  const UserFilesPage({required this.userId, super.key});

  @override
  State<UserFilesPage> createState() => _UserFilesPageState();
}

class _UserFilesPageState extends State<UserFilesPage> {
  List<Map<String, dynamic>> userFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserFiles();
  }

  Future<void> fetchUserFiles() async {
    final url = Uri.parse('http://localhost:3000/api/files/user/${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        userFiles = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      print('Erreur: ${response.body}');
      setState(() => isLoading = false);
    }
  }



  void _goToAddFileSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddFileWidget(userId: widget.userId),
      ),
    );

    if (result == true) {
      fetchUserFiles(); // rafraîchir après ajout
    }
  }




Future<void> _downloadFile(String url, String filename) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Impossible d\'ouvrir le lien')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes fichiers")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userFiles.length,
              itemBuilder: (context, index) {
                final file = userFiles[index];
                return ListTile(
                  title: Text(file['nom'] ?? 'Sans nom'),
                  subtitle: Text(file['mime_type'] ?? 'Inconnu'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _downloadFile(file['signedUrl'], file['nom']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddFileSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
