import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String? currentUserId;

  // Instance de FlutterSecureStorage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Lecture sécurisée des données
    final userJson = await secureStorage.read(key: 'userData');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        currentUserId = user['id']?.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      // Afficher un loader pendant la récupération
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // appBar: const MyWidgetAppBar(
      //   title: "Messagerie",
      //   logoPath: Constants.avatar,
      //   backgroundColor: Constants.appBarBackgroundColor,
      //   isBackButtonVisible: true,
      //   showNotifications: false,
      //   showChat: false,
      //   showSearch: true,
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('conversations')
              .where('members', arrayContains: currentUserId)
              .orderBy('lastUpdated', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final conversations = snapshot.data!.docs;

            if (conversations.isEmpty) {
              return const Center(child: Text("Aucune conversation trouvée"));
            }

            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                final data = conv.data() as Map<String, dynamic>;

                final isGroup = data['isGroup'] ?? false;
                final groupName = data['groupName'] ?? '';
                final lastMessage = data['lastMessage'] ?? '';
                final lastUpdated = data['lastUpdated'] != null
                    ? (data['lastUpdated'] as Timestamp).toDate()
                    : null;
                final groupPhotoURL = data['groupPhotoURL'] ?? '';

                String title = isGroup ? groupName : "Conversation privée";

                // Pour une conversation privée, tu peux afficher le nom de l'autre membre
                if (!isGroup) {
                  List members = data['members'] ?? [];
                  String otherUserId = members.firstWhere((id) => id != currentUserId, orElse: () => '');
                  title = otherUserId; // À remplacer par le nom de l'autre utilisateur si tu as ses infos
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        groupPhotoURL.isNotEmpty ? NetworkImage(groupPhotoURL) : null,
                    child: groupPhotoURL.isEmpty ? Icon(isGroup ? Icons.group : Icons.person) : null,
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: lastUpdated != null
                      ? Text(
                          "${lastUpdated.hour.toString().padLeft(2, '0')}:${lastUpdated.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      : null,
                  onTap: () {
                    context.push(
                      '/chat/${conv.id}',
                      extra: currentUserId,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/createConv');
        },
        backgroundColor: Constants.turquoiseDark,
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
