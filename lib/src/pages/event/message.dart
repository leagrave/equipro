import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientMessageListWidget.dart';
import 'package:flutter/material.dart';


class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
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
            colors: [Constants.appBarBackgroundColor, Constants.appBarBackgroundColor],//[Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: MessageListWidget(), 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //on va diriger vers la selection d'un contact client + la possiblilite de creer un groupe
          //context.push("/chat");
        },
        backgroundColor: Constants.turquoiseDark,
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
