import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/horizontalScrollWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/event/evenementsListWidget.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:  Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SizedBox.expand( 
          child: Column(
            children: [
              const SizedBox(height: Constants.paddingMedium),
              HorizontalScrollWidget(),
              const SizedBox(height: Constants.paddingMedium),
              MyWidgetAppointments(),
              //Expanded(child: MyWidgetNotifications()), 
            ],
          ),
        ),
      ),
    );
  }
}
