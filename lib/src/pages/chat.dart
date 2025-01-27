import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:math';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final types.User _currentUser = const types.User(id: '1'); 
  final types.User _otherUser = const types.User(
    id: '2',
    firstName: 'Bot',
    imageUrl: 'https://via.placeholder.com/150', 
  );

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Charger des messages initiaux
  }

  void _loadMessages() {
    final textMessage = types.TextMessage(
      author: _otherUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'Bienvenue dans le chat ! Comment puis-je vous aider ?',
    );
    setState(() {
      _messages.add(textMessage);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    _simulateBotResponse(message.text); // Simuler une réponse automatique
  }

  void _simulateBotResponse(String userMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      final botResponse = types.TextMessage(
        author: _otherUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: _generateBotReply(userMessage),
      );
      setState(() {
        _messages.insert(0, botResponse);
      });
    });
  }

  String _generateBotReply(String userMessage) {
    const responses = [
      "Je suis là pour vous aider !",
      "Pouvez-vous préciser votre question ?",
      "Merci pour votre message.",
      "Je travaille actuellement sur une réponse pour vous.",
      "Je ne suis qu'un bot, mais je ferai de mon mieux pour vous aider !"
    ];
    return responses[Random().nextInt(responses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: _otherUser.firstName ?? 'Utilisateur',
        logoPath: Constants.avatar,
        onNotificationTap: () {},
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
        showActions: false,
      ),
      body: Stack(
            children: [
              // Chat
              Expanded(
                child: Chat(
                  messages: _messages,
                  onSendPressed: _handleSendPressed,
                  user: _currentUser,
                  theme: const DefaultChatTheme(
                    inputBackgroundColor: Constants.gradientStartColor,
                    primaryColor: Constants.turquoiseDark,
                    sendButtonIcon: Icon(Icons.send, color: Constants.gradientEndColor),
                  ),
                ),
              ),
            ],      
      ),
    );
  }
}
