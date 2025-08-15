import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/event/eventCardWidget.dart';
import 'package:flutter/material.dart';

import 'package:equipro/src/models/event.dart';  

class EventPage extends StatelessWidget {
  final Event event;

  EventPage({required this.event});

  @override
  Widget build(BuildContext context) {
    // Formatage des heures en français
    // String heureDebut = DateFormat.Hm('fr_FR').format(event.heureDebut);
    // String heureFin = DateFormat.Hm('fr_FR').format(event.heureFin);

    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Mon événement',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: EventCardWidget(
          event: event,  
          openWithCreateEventPage: false,  
          onEventUpdated: (updatedEvent) {
            // Handle the event update logic here
          },
        ), 
      ),
    );
  }
}
