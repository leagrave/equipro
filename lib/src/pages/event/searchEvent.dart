import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/models/event.dart';


class SearchEventPage extends StatefulWidget {
  const SearchEventPage({Key? key}) : super(key: key);

  @override
  _SearchEventPageState createState() => _SearchEventPageState();
}

class _SearchEventPageState extends State<SearchEventPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Event> _events = [
    Event(
      idEvent: 1,
      idClient: 101,
      eventName: "Vérification annuelle",
      adresseEcurie: "Écurie Saint-Michel",
      dateDebut: DateTime(2025, 2, 10),
      dateFin: DateTime(2025, 2, 10),
      heureDebut: DateTime(2025, 2, 10, 9, 0),
      heureFin: DateTime(2025, 2, 10, 10, 0),
      notes: "Contrôle complet des chevaux.",
    ),
    Event(
      idEvent: 2,
      idClient: 102,
      eventName: "Consultation spéciale",
      adresseEcurie: "Écurie du Vent",
      dateDebut: DateTime(2025, 3, 15),
      dateFin: DateTime(2025, 3, 15),
      heureDebut: DateTime(2025, 3, 15, 14, 30),
      heureFin: DateTime(2025, 3, 15, 15, 30),
      notes: "Examen approfondi du cheval blessé.",
    ),
  ];
  List<Event> _filteredEvents = [];
  bool _hasSearched = false;

  void _filterEvents(String query) {
    setState(() {
      _hasSearched = query.isNotEmpty;
      _filteredEvents = _events.where((event) {
        return event.eventName.toLowerCase().contains(query.toLowerCase()) ||
            event.adresseEcurie.toLowerCase().contains(query.toLowerCase()) ||
            event.dateDebut.toString().contains(query) ||
            event.dateFin.toString().contains(query) ||
            event.heureDebut.toString().contains(query) ||
            event.heureFin.toString().contains(query) ||
            (event.notes?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Rechercher événement',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
        showChat: false,
        showNotifications: false,
        showSearch: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.appBarBackgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Barre de recherche stylisée
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterEvents,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)),
                    hintText: "Rechercher un événement",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Liste des résultats de recherche
            Expanded(
              child: !_hasSearched
                  ? const SizedBox()
                  : _filteredEvents.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucun événement trouvé',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = _filteredEvents[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  event.eventName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "${event.adresseEcurie} • ${event.dateDebut.day}/${event.dateDebut.month}/${event.dateDebut.year}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                leading: const Icon(Icons.event, color: Colors.white),
                                onTap: () {
                                  context.push('/eventDetails', extra: {'idEvent': event.idEvent});
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
