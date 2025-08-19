import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equipro/src/services/apiService.dart';
import 'dart:convert';

class UserFilesPage extends StatefulWidget {
  final String userId;

  const UserFilesPage({required this.userId, super.key});

  @override
  State<UserFilesPage> createState() => _UserFilesPageState();
}

class _UserFilesPageState extends State<UserFilesPage> {
  final _storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> userFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserFiles();
  }

  Future<void> fetchUserFiles() async {
    try {
      final response = await ApiService.getWithAuth('/files/user/${widget.userId}');
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
    } catch (e) {
      print('Erreur lors de la récupération des fichiers: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _downloadFile(String url, String filename) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir le lien')),
      );
    }
  }

  Future<void> _goToCreateInvoice() async {
    // Récupérer le proID depuis le secure storage
    String? proID = await _storage.read(key: 'pro_id');

    if (proID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : pro_id introuvable')),
      );
      return;
    }

    // Exemple de sélection d'utilisateur et cheval
    var selectedUsers = [{'id': widget.userId}];
    // Navigation vers createInvoice
    context.push('/createInvoice', extra: {
      'proID': proID,
      'user_id': selectedUsers.map((u) => u['id']).toList(),

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF29323f),
      appBar: AppBar(
        title: const Text("Mes fichiers", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF28313e),
      
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00B8D9)))
          : ListView.builder(
              itemCount: userFiles.length,
              itemBuilder: (context, index) {
                final file = userFiles[index];
                return Card(
                  color: const Color(0xFF333d47),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      file['nom'] ?? 'Sans nom',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      file['mime_type'] ?? 'Inconnu',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download, color: Color(0xFF00B8D9)),
                      onPressed: () => _downloadFile(file['signedUrl'], file['nom']),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateInvoice,
        backgroundColor: const Color(0xFF00B8D9),
        child: const Icon(Icons.receipt_long),
      ),
    );
  }
}
