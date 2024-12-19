import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/widgets/list/clientListWidget.dart';

class searchClientWidget extends StatefulWidget {
  final Function(Client) onClientTap;
  final VoidCallback onCreateClient;

  const searchClientWidget({
    Key? key,
    required this.onClientTap,
    required this.onCreateClient,
  }) : super(key: key);

  @override
  _searchClientWidgetState createState() => _searchClientWidgetState();
}

class _searchClientWidgetState extends State<searchClientWidget> {
  List<Client> clients = [
    Client(
      nom: "Dupont",
      prenom: "Jean",
      tel: "0123456789",
      mobile: "0612345678",
      email: "jean.dupont@example.com",
      societe: "Dupont SARL",
      civilite: "Monsieur",
      isSociete: true,
      derniereVisite: DateTime(2024, 12, 1),
      prochaineIntervention: DateTime(2024, 12, 15),
      adresse: "123 Rue Principale, Paris",
      adresseFacturation: "123 Rue Principale, Paris",
      adresses: ["123 Rue Principale, Paris", "123 Rue Principale, Paris"],
      ville: "Lyon",
      notes: "Client important",
    ),
    Client(
      nom: "Martin",
      prenom: "Pierre",
      tel: "0123456489",
      mobile: "0123456489",
      email: "pierre.martin@example.com",
      societe: "",
      civilite: "Monsieur",
      isSociete: false,
      derniereVisite: DateTime(2024, 12, 1),
      prochaineIntervention: DateTime(2024, 12, 15),
      adresse: "456 Rue des Champs, Lyon",
      adresseFacturation: "789 Rue de Paris, Pertuis",
      adresses: ["456 Rue des Champs, Lyon", "789 Rue de Paris, Pertuis"],
      ville: "Lyon",
      notes: "Client important",
    ),
  ];

  List<Client> filteredClients = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredClients = clients;
  }

  void filterClients(String query) {
    setState(() {
      searchQuery = query;
      filteredClients = clients.where((client) {
        final fullName = "${client.nom} ${client.prenom}".toLowerCase();
        final fullTel = "${client.tel} ".toLowerCase();
        final cityRegion = "${client.ville} ${client.region ?? ''}".toLowerCase();
        return fullName.contains(query.toLowerCase()) ||
            cityRegion.contains(query.toLowerCase()) ||
            fullTel.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de recherche
        Container(
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
            onChanged: filterClients,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)),
              hintText: "Rechercher par nom, prénom, tel ou ville",
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Liste filtrée
        Expanded(
          child: ClientListWidget(
            filteredClients: filteredClients,
            onClientTap: widget.onClientTap, // Appelle la fonction passée depuis le parent
          ),
        ),
      ],
    );
  }
}
