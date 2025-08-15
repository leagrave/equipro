import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String currentUserId;

  const ChatPage({
  Key? key, 
  required this.conversationId,
  required this.currentUserId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final types.User _currentUser;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _currentUser = types.User(id: widget.currentUserId);
    print(_currentUser.id);
      WidgetsBinding.instance.addPostFrameCallback((_) {
    _listenToMessages();
  });
  }

  void _listenToMessages() {
    FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)  // Utiliser "timestamp" ici
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();

        // Convertir Timestamp Firebase en int millisec depuis epoch
        final timestamp = (data['timestamp'] as Timestamp?)?.millisecondsSinceEpoch;

        return types.TextMessage(
          author: types.User(id: data['senderId']),
          createdAt: timestamp,
          id: doc.id,
          text: data['text'] ?? '',
          // Ici tu peux aussi gérer le champ type, attachmentURL, etc. selon besoin
        );
      }).toList();

      setState(() {
        _messages = messages;
      });
    });
  }


  void _handleSendPressed(types.PartialText message) {
    final newMessage = {
      'senderId': _currentUser.id,
      'timestamp': Timestamp.now(),  // Timestamp Firestore
      'text': message.text,
      'type': 'text',                // tu peux préciser le type pour plus tard
      'attachmentURL': null,         // par défaut null si pas de média
      'readBy': [_currentUser.id],   // message déjà lu par l’auteur
    };

    FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationId)
        .collection('messages')
        .add(newMessage);

    FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationId)
        .update({
          'lastMessage': message.text,
          'lastUpdated': Timestamp.now(),
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversation")),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _currentUser,
      ),
    );
  }
}
