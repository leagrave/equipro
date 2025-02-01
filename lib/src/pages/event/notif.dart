import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/event/histoNotifListWidget.dart';
import 'package:flutter/material.dart';

class NotifsPage extends StatefulWidget {
  const NotifsPage({Key? key}) : super(key: key);

  @override
  _NotifsPageState createState() => _NotifsPageState();
}

class _NotifsPageState extends State<NotifsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: "Notifications",
        logoPath: Constants.avatar,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
        showNotifications: false,
        showChat: false,
      ),
      body: Container(  
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Chat
            Positioned.fill(
              child: HistoriqueNotificationListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
