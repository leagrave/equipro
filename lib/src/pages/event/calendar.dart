import 'package:equipro/src/widgets/event/calendarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:equipro/src/widgets/event/calendarWidget.dart';
import 'package:equipro/src/models/event.dart';


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Vue par défaut (Semaine)
  CalendarView _calendarView = CalendarView.week;
  final List<Event> _allEvents = _getEvents();
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _filteredEvents = _allEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Rechercher un événement',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                _filteredEvents = _searchEvents(query);
              });
            },
          ),
        ),
        // Widget calendrier avec la vue dynamique
        Expanded(
          child: CalendarWidget(
            calendarView: _calendarView,
            events: _filteredEvents, // Adapter à la liste des événements
            onViewChanged: (newView) {
              setState(() {
                _calendarView = newView;
              });
            },
          ),
        ),
      ],
    );
  }

  // Filtrer les événements selon la recherche
  List<Event> _searchEvents(String query) {
    if (query.isEmpty) {
      return _allEvents;
    }

    return _allEvents.where((event) {
      // Chercher dans le nom de l'événement, du client, du cheval ou de l'écurie
      return event.eventName.toLowerCase().contains(query.toLowerCase()) ||
          event.adresseEcurie.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Méthode pour obtenir les événements
  static List<Event> _getEvents() {
    return [
      Event(
        idEvent: 1,
        idClient: 101,
        eventName: "Consultation Cheval",
        adresseEcurie: "17 rue du test 13110 port de bouc",
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
        adresseEcurie: "17 rue du test 13110 port de bouc",
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
