import 'package:equipro/src/models/horse.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/widgets/list/clientListWidget.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class ListClientPage extends StatefulWidget {
  final String? idClient;

  const ListClientPage({Key? key, this.idClient}) : super(key: key);

  @override
  _ListClientPageState createState() => _ListClientPageState();
}

class _ListClientPageState extends State<ListClientPage> {
  List<Client> clients = [
  Client(
    idClient: 1,
    nom: "Dupont",
    prenom: "Jean",
    tel: "0123456789",
    tel2: "0612345678",
    email: "jean.dupont@example.com",
    societe: "Dupont SARL",
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
    idClient: 2,
    nom: "Martin",
    prenom: "Pierre",
    tel: "0123456489",
    tel2: "0123456489",
    email: "pierre.martin@example.com",
    societe: "", 
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
      Client(
    idClient: 3,
    nom: "Sophie",
    prenom: "Lacroix",
    tel: "0123456489",
    tel2: "0123456489",
    email: "pierre.martin@example.com",
    societe: "",
    civilite: "Monsieur",
    isSociete: false,
    derniereVisite: DateTime(2024, 12, 1),
    prochaineIntervention: DateTime(2024, 12, 15),
    adresse: "456 Rue des Champs, Paris",
    adresseFacturation: "789 Rue de Paris, Pertuis",
    adresses: ["456 Rue des Champs, Lyon", "789 Rue de Paris, Pertuis"],
    ville : "Paris",
    notes: "Client important",
    ),
  Client(
    idClient: 4,
    nom: "Eve",
    prenom: "Gomez",
    tel: "0123456489",
    tel2: "0123456489",
    email: "pierre.martin@example.com",
    societe: "", 
    civilite: "Monsieur",
    isSociete: false,
    derniereVisite: DateTime(2024, 12, 1),
    prochaineIntervention: DateTime(2024, 12, 15),
    adresse: "456 Rue des Champs, Marseille",
    adresseFacturation: "789 Rue de Paris, Pertuis",
    adresses: ["456 Rue des Champs, Marseille", "789 Rue de Paris, Pertuis"],
    ville : "Marseille",
    notes: "Client important",
    ),
  ];

List<Horse> horses = [
      Horse(
      id: 1,
      idClient: 1,
      name: "Eclair",
      ownerId: 1,
      adresse: "123 Rue Principale, Paris",
      age: 7,
      race: "Pur-sang",
      lastAppointmentDate: DateTime(2024, 12, 10),
      notes: "Sage durant le soin"
    ),
    Horse(
      id: 2,
      idClient: 1,
      name: "Tempête",
      ownerId: 2,
      adresse: "123 Rue Principale, Paris",
      age: 5,
      race: "Frison",
      lastAppointmentDate: null,
      notes: "Bouge la tête"
    ),
    Horse(
      id: 3,
      idClient: 2,
      name: "Foudre",
      ownerId: 1,
      adresse: "123 Rue Principale, Paris",
      age: 9,
      race: "Arabe",
      lastAppointmentDate: DateTime(2024, 11, 20),
      notes: "Doit tourner"
    ),
    Horse(
      id: 4,
      idClient: 1,
      name: "Brume",
      ownerId: 3,
      adresse: "123 Rue Principale, Paris",
      age: 6,
      race: "Camarguais",
      lastAppointmentDate: null,
      notes: ""
    ),
    Horse(
      id: 5,
      idClient: 1,
      name: "Bubule",
      ownerId: 2,
      adresse: "123 Rue Principale, Paris",
      age: 5,
      race: "Frison",
      lastAppointmentDate: null,
      notes: "Bouge la tête"
    ),
    Horse(
      id: 6,
      idClient: 1,
      name: "Truck",
      ownerId: 2,
      adresse: "123 Rue Principale, Paris",
      age: 5,
      race: "Frison",
      lastAppointmentDate: null,
      notes: "Bouge la tête"
    ),
    Horse(
      id: 7,
      idClient: 1,
      name: "Chouette",
      ownerId: 2,
      adresse: "123 Rue Principale, Paris",
      age: 5,
      race: "Frison",
      lastAppointmentDate: null,
      notes: "Bouge la tête"
    )
  ];

  

  List<Client> filteredClients = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (widget.idClient != null) {
      filteredClients = clients.where((client) => client.idClient == widget.idClient).toList();
    } else {
      filteredClients = clients;
    }
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
  context.push('/managementClient', extra: client);
}

void navigateToCreateClientPage() async {
  // Naviguer vers la page de création de client et récupérer le nouveau client
  final newClient = await context.push('/createClient');

  // Vérifier si le retour est du type Client
  if (newClient != null && newClient is Client) {
    setState(() {
      clients.add(newClient);
      filteredClients = clients;
    });
  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
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
                  onChanged: filterClients,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)), 
                    hintText: "Rechercher par nom, prénom, cheval, tel ou ville",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),


              // Liste des clients avec leurs chevaux
              Expanded(
                child: ClientListWidget(
                  filteredClients: filteredClients,
                  horses: horses, 
                  onClientTap: (client) {
                    //final clientHorses = horses.where((horse) => horse.idClient == client.idClient).toList();
                    navigateToManagementClientPage(client);
                  },
                ),
              ),


            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateClientPage,
        backgroundColor: Constants.turquoiseDark,
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
