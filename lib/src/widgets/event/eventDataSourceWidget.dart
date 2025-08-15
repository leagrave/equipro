import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:equipro/src/models/event.dart';


class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].heureDebut;

  @override
  DateTime getEndTime(int index) => appointments![index].heureFin;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => Colors.blue;  // Tu peux personnaliser la couleur ici si nécessaire

  @override
  bool isAllDay(int index) => false;  // Définir si l'événement est de toute la journée (peut être modifié selon les données)

  // Ajouter des méthodes pour obtenir des informations supplémentaires sur l'événement
  String getClientName(int index) => "Client ID: ${appointments![index].idClient}";
  String getAdresseEcurie(int index) => appointments![index].addressEcurie;
}
