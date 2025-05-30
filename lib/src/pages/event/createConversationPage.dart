import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreateConversationPage extends StatefulWidget {
  const CreateConversationPage({Key? key}) : super(key: key);

  @override
  _CreateConversationPageState createState() => _CreateConversationPageState();
}

class _CreateConversationPageState extends State<CreateConversationPage> {
  List<String> selectedUserIds = [];
  String? currentUserId = "1";

  final TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        currentUserId = user['id']?.toString();
      });
    }
  }

  // Exemple d'utilisateurs (à remplacer par une requête Firestore dans ton cas)
  final List<Map<String, dynamic>> users = [
    {"uid": "a17075ad2015405c8a1e38a0a399c416", "displayName": "Julien Morel"},
    {"uid": "9cb48b1b25294f578ee3d423b45846fb", "displayName": "Claire Dupont"},
    {"uid": "903b898a7fdc41adbe56e95989f61f1e", "displayName": "Mathieu Lemoine"},
  ];

  void toggleSelection(String uid) {
    setState(() {
      if (selectedUserIds.contains(uid)) {
        selectedUserIds.remove(uid);
      } else {
        selectedUserIds.add(uid);
      }
    });
  }

  Future<void> createConversation() async {
    if (selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner au moins un contact")),
      );
      return;
    }

    if (groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez renseigner un nom de groupe")),
      );
      return;
    }

    List<String> members = List.from(selectedUserIds);
    if (!members.contains(currentUserId)) {
      members.add(currentUserId ?? "");
    }

    try {
      final conversationDoc = await FirebaseFirestore.instance.collection('conversations').add({
        'groupName': groupNameController.text.trim(),
        'isGroup': true,
        'lastMessage': 'Conversation crée',
        'lastUpdated': FieldValue.serverTimestamp(),
        'members': members,
        
        //'groupPhotoURL': '', // Tu peux y mettre un lien ou un champ upload plus tard
      });

      await conversationDoc.collection('messages').add({
        'readBy': [currentUserId],
        'senderId': currentUserId,
        'text': 'Conversation créée',
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
        'attachmentURL': null,
            });

      print('Conversation créée avec l\'ID : ${conversationDoc.id}');
      Navigator.pop(context, conversationDoc.id);
    } catch (e) {
      print('Erreur création conversation : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création de la conversation : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle conversation"),
        actions: [
          TextButton(
            onPressed: createConversation,
            child: const Text("Créer", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: groupNameController,
              decoration: const InputDecoration(
                labelText: "Nom du groupe",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isSelected = selectedUserIds.contains(user["uid"]);

                return ListTile(
                  title: Text(user["displayName"]),
                  trailing: isSelected
                      ? const Icon(Icons.check_box, color: Colors.blue)
                      : const Icon(Icons.check_box_outline_blank),
                  onTap: () => toggleSelection(user["uid"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
