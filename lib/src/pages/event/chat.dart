import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final int idClient; 

  const ChatPage({Key? key, required this.idClient}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final types.User _currentUser = const types.User(id: '1'); 
  late types.User _otherUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientData(); 
  }

  /// Charger les infos du client
  void _loadClientData() async {
    // TODO : Remplacer par un appel à la base de données
    final clientData = _getClientInfo(widget.idClient);

    if (clientData != null) {
      setState(() {
        _otherUser = types.User(
          id: widget.idClient.toString(),
          firstName: clientData['prenom'],
          lastName: clientData['nom'],
          imageUrl: 'https://via.placeholder.com/150',
        );
        _messages.addAll(_loadMessages(widget.idClient));
        _isLoading = false;
      });
    }
  }

  /// Simule la récupération des informations client
  Map<String, String>? _getClientInfo(int idClient) {
    // Simulation d'une base de données
    final clients = {
      1: {'nom': 'Dupont', 'prenom': 'Jean'},
      2: {'nom': 'Martin', 'prenom': 'Sophie'},
      3: {'nom': 'Durand', 'prenom': 'Paul'},
      4: {'nom': 'test', 'prenom': 'test'},
    };

    return clients[idClient];
  }

  /// Simule le chargement des messages du client
  List<types.Message> _loadMessages(int idClient) {
    return [
      types.TextMessage(
        author: types.User(id: idClient.toString()),
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Bonjour, j’ai une question sur ma prochaine consultation.',
      ),
    ];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: _isLoading ? 'Chargement...' : '${_otherUser.firstName} ${_otherUser.lastName}',
        logoPath: Constants.avatar,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
        showNotifications: false,
        showChat: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _currentUser,
              theme: const DefaultChatTheme(
                inputBackgroundColor: Constants.gradientStartColor,
                primaryColor: Constants.turquoiseDark,
                sendButtonIcon: Icon(Icons.send, color: Constants.gradientEndColor),
              ),
            ),
    );
  }
}
