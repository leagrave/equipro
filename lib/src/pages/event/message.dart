import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientMessageListWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: "Messagerie",
        logoPath: Constants.avatar,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
        showActions: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: MessageListWidget(), // Supprime `Expanded` et utilise directement le widget
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/chat");
        },
        backgroundColor: Constants.appBarBackgroundColor,
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
