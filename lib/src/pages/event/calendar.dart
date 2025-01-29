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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Constants.appBarBackgroundColor, Constants.turquoise],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
         children: [
          // Barre de Recherche
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)), 
                    hintText: "Rechercher",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),
          // Widget calendrier avec la vue dynamique
          Expanded(
            child: CalendarWidget(
              calendarView: _calendarView,
              events: _filteredEvents, 
              onViewChanged: (newView) {
                setState(() {
                  _calendarView = newView;
                });
              },
            ),
          ),
        ],
      ),
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
