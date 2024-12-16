import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/src/widgets/list/clientListWidget.dart';
import 'package:equipro/src/pages/client/createClient.dart';
import 'package:equipro/router/router.dart';

class ListClientPage extends StatefulWidget {
  @override
  _ListClientPageState createState() => _ListClientPageState();
}

class _ListClientPageState extends State<ListClientPage> {
  List<Client> clients = [
  Client(
    nom: "Dupont",
    prenom: "Jean",
    tel: "0123456789",
    mobile: "0612345678",
    email: "jean.dupont@example.com",
    societe: "Dupont SARL", // Exemple de société
    civilite: "Monsieur",
    isSociete: true,
    derniereVisite: DateTime(2024, 12, 1),
    prochaineIntervention: DateTime(2024, 12, 15),
    adresse: "123 Rue Principale, Paris",
    adresseFacturation: "123 Rue Principale, Paris",
    adresses: ["123 Rue Principale, Paris", "123 Rue Principale, Paris"],
    ville : "Lyon",
    notes: "Client important",
  ),
    Client(
    nom: "Martin",
    prenom: "Pierre",
    tel: "0123456489",
    mobile: "0123456489",
    email: "pierre.martin@example.com",
    societe: "", // Exemple de société
    civilite: "Monsieur",
    isSociete: false,
    derniereVisite: DateTime(2024, 12, 1),
    prochaineIntervention: DateTime(2024, 12, 15),
    adresse: "456 Rue des Champs, Lyon",
    adresseFacturation: "789 Rue de Paris, Pertuis",
    adresses: ["456 Rue des Champs, Lyon", "789 Rue de Paris, Pertuis"],
    ville : "Lyon",
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
      
      // Vérifier si `client.region` est nul avant de l'utiliser
      final cityRegion = "${client.ville} ${client.region ?? ''}".toLowerCase();
      
      return fullName.contains(query.toLowerCase()) ||
          cityRegion.contains(query.toLowerCase()) ||
          fullTel.contains(query.toLowerCase());
    }).toList();
  });
}


void navigateToManagementClientPage(Client client) async {
  await Navigator.pushNamed(
    context,
    '/managementClient',  // Le nom de la route
    arguments: client,     // Passer le client comme argument
  );
}

  void navigateToCreateClientPage() async {
    final newClient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateClientPage()),
    );
    if (newClient != null) {
      setState(() {
        clients.add(newClient);
        filteredClients = clients;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Agenda clients',
        logoPath: 'assets/images/image-logo.jpg', // Le chemin du logo
        onNotificationTap: () {
          // Action lors du clic sur l'icône de notification
          print('Notifications');
        },
        backgroundColor: AppColors.appBarBackgroundColor, 
        
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding autour du contenu
          child: Column(
            children: [
              // Recherche
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
                  onChanged: filterClients,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)), // Bleu-gris profond
                    hintText: "Rechercher par nom, prénom, tel ou ville",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ClientListWidget(
                  filteredClients: filteredClients,
                  onClientTap: (client) {
                    navigateToManagementClientPage(client);  // Passer le client sélectionné à la page de gestion
                  },
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateClientPage,
        backgroundColor: AppColors.appBarBackgroundColor, // Gris ardoise
        child: const Icon(Icons.add, color: AppColors.buttonBackgroundColor),
      ),
      bottomNavigationBar: MyWidgetBottomNavBar(
        onTap: (index) {
          // Navigation selon l'index sélectionné
        },
      ),
    );
  }
}
