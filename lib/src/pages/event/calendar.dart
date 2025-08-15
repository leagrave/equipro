import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/calendar/calendarWidget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:equipro/src/models/event.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Vue par défaut (Semaine)
  CalendarView _calendarView = CalendarView.week;
  final List<Event> _allEvents = _getEvents();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: Constants.gradientBackground,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Widget calendrier avec la vue dynamique
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CalendarWidget(
                calendarView: _calendarView,
                events: _allEvents, 
                onViewChanged: (newView) {
                  setState(() {
                    _calendarView = newView;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour obtenir les événements
  static List<Event> _getEvents() {
    return [
      Event(
        idEvent: 1,
        idClient: 101,
        eventName: "Consultation Cheval",
        addressEcurie: "17 rue du test 13110 port de bouc",
        dateDebut: DateTime.now(),
        dateFin: DateTime.now().add(Duration(hours: 1)),
        heureDebut: DateTime.now(),
        heureFin: DateTime.now().add(Duration(hours: 1)),
        idEcurie: 201,
        idHorse: 301,
      ),
      Event(
        idEvent: 2,
        idClient: 102,
        eventName: "Entretien Dentaire",
        addressEcurie: "17 rue du test 13110 port de bouc",
        dateDebut: DateTime.now().add(Duration(days: 1)),
        dateFin: DateTime.now().add(Duration(days: 1, hours: 2)),
        heureDebut: DateTime.now().add(Duration(days: 1)),
        heureFin: DateTime.now().add(Duration(days: 1, hours: 2)),
        idEcurie: 202,
        idHorse: 302,
      ),
    ];
  }
}
