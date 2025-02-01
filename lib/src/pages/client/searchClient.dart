import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class SearchClient {
  final int idClient;
  final String nom;
  final String prenom;

  SearchClient({required this.idClient, required this.nom, required this.prenom});
}

class SearchClientPage extends StatefulWidget {
  const SearchClientPage({Key? key}) : super(key: key);

  @override
  _SearchClientPageState createState() => _SearchClientPageState();
}

class _SearchClientPageState extends State<SearchClientPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<SearchClient> _clients = [
    SearchClient(idClient: 1, nom: 'Dupont', prenom: 'Jean'),
    SearchClient(idClient: 2, nom: 'Martin', prenom: 'Sophie'),
    SearchClient(idClient: 3, nom: 'Lemoine', prenom: 'Paul'),
    SearchClient(idClient: 4, nom: 'Durand', prenom: 'Emma'),
  ];
  List<SearchClient> _filteredClients = [];
  bool _hasSearched = false;

  void _filterClients(String query) {
    setState(() {
      _hasSearched = query.isNotEmpty;
      _filteredClients = _clients
          .where((client) =>
              client.nom.toLowerCase().contains(query.toLowerCase()) ||
              client.prenom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Rechercher client',
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
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  onChanged: _filterClients,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)),
                    hintText: "Rechercher",
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
                  : _filteredClients.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucun client trouvé',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredClients.length,
                          itemBuilder: (context, index) {
                            final client = _filteredClients[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${client.prenom} ${client.nom}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                leading: const Icon(Icons.person, color: Colors.white),
                                onTap: () {
                                    context.push('/chat', extra: {'idClient': client.idClient} );
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
