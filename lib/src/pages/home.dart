import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/event/notificationsListWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/event/evenementsListWidget.dart';

/// Widget pour la barre de navigation
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox.expand( 
          child: Column(
            children: [
              Expanded(child: MyWidgetAppointments()), 
              Expanded(child: MyWidgetNotifications()), 
            ],
          ),
        ),
      ),
    );
  }
}
