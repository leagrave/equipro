import 'package:equipro/src/models/ecurie.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
import 'package:equipro/src/widgets/card/ecurie/ecurieCardWidget.dart';
import 'package:equipro/src/widgets/card/ecurie/ecuriesComboCardWidget.dart';
import 'package:equipro/src/widgets/card/horse/horseAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/horse/horseCardWidget.dart';
import 'package:equipro/src/models/client.dart'; 


class CreateHorsePage extends StatefulWidget {
  final int? idClient;

  const CreateHorsePage({this.idClient, Key? key}) : super(key: key);

  @override
  _CreateHorsePageState createState() => _CreateHorsePageState();
}

class _CreateHorsePageState extends State<CreateHorsePage> {
  final _formKey = GlobalKey<FormState>();

  // Champs pour l'écurie
  int idEcurie = 0;
  String nameEcurie = "";
  int ownerId = 0;
  String adresseEcurie = "";

  // Champs pour le client
  int idClient = 0;
  String nom = '';
  String prenom = '';
  String tel = '';
  String tel2 = '';
  String email = '';
  String adressePerso = '';
  String adresseEcuries = '';
  String ville = '';
  String region = '';
  DateTime derniereVisite = DateTime.now();
  bool isSociete = false;

  // Champs pour le cheval
  String name = '';
  int age = 0;
  String race = '';
  String? color;
  String? feedingType;
  String? activityType;
  DateTime? lastAppointmentDate;
  String? adresse;
  String? notes;
  int? idEcurieCheval;

  // Gestion de l'adresse et de la localisation
  String horseAddress = '';
  double latitude = 0.0;
  double longitude = 0.0;

  List<Client> clientList = [];  
  Client? selectedClient; 

  List<Ecurie> ecurieList = [];  
  Ecurie? selectedEcurie; 

  bool showClientCard = false; 
  bool showEcurieCard = false; 

  @override
  void initState() {
    super.initState();
    _loadClients();  
    _loadEcruries();
    if (widget.idClient != null) {
      // Si idClient est fourni, on sélectionne le client correspondant
      selectedClient = clientList.firstWhere(
        (client) => client.idClient == widget.idClient,
        orElse: () => Client(
          idClient: -1,
          nom: 'Inconnu',
          prenom: 'Inconnu',
          tel: ''
        ),
      );
    }
  }

  void _loadClients() async {
    // Simuler le chargement des clients (à remplacer par une vraie requête)
    setState(() {
      clientList = [
        Client(idClient: 1, nom: "Dupont", prenom: "Jean", tel: "0123456789"),
        Client(idClient: 2, nom: "Martin", prenom: "Pierre", tel: "0123456489"),
        Client(idClient: 3, nom: "Sophie", prenom: "Lacroix", tel: "0123456489"),
        Client(idClient: 4, nom: "Eve", prenom: "Gomez", tel: "0123456489"),
      ];
    });
  }

    void _loadEcruries() async {
    // Simuler le chargement des ecruries (à remplacer par une vraie requête)
    setState(() {
      ecurieList = [
        Ecurie(idEcurie: 0, name: "", ownerId: 0, adresse: ""),
        Ecurie(idEcurie: 1, name: "Ecruie Triomphe", ownerId: 2, adresse: ""),
        Ecurie(idEcurie: 2, name: "Deven", ownerId: 1, adresse: "rue du pavillon"),
        Ecurie(idEcurie: 3, name: "Ecurie entressen", ownerId: 3, adresse: "boulevard de la nuée"),
        Ecurie(idEcurie: 4, name: "Etoile", ownerId: 4, adresse: ""),
      ];
    });
  }

  void _onClientChanged(Client? newClient) {
    setState(() {
      selectedClient = newClient;
    });
  }

    void _onEcurieChanged(Ecurie? newEcurie) {
    setState(() {
      selectedEcurie = newEcurie;
    });
  }

  // Fonction pour afficher/masquer la clientCardWidget
  void _toggleClientCard() {
    setState(() {
      showClientCard = !showClientCard;  
    });
  }

  void _onSaveClientCard() {
    setState(() {
      showClientCard = false;  
    });
  }

    // Fonction pour afficher/masquer la EcurieCardWidget
  void _toggleEcurieCard() {
    setState(() {
      showEcurieCard = !showEcurieCard;  
    });
  }

  void _onSaveEcurieCard() {
    setState(() {
      showEcurieCard = false;  
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Créer un cheval',
        logoPath: Constants.logo,
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Appel du widget combo Client
                ClientsComboCardWidget(
                  clientList: clientList,
                  selectedClient: selectedClient,
                  onClientChanged: _onClientChanged,
                  onAddClientPressed: _toggleClientCard,
                ),

                // Afficher la clientCardWidget si l'état "showClientCard" est vrai
                if (showClientCard) 
                ClientCardWidget(
                  client: Client(
                    idClient: 4,  
                    nom: nom,    
                    prenom: prenom,
                    tel: tel,  
                    email: email, 
                    isSociete: isSociete, 
                  ),
                  onClientUpdated: (updatedClient) {
                    setState(() {
                      nom = updatedClient.nom;
                      prenom = updatedClient.prenom;
                      tel = updatedClient.tel;
                      email = updatedClient.email ?? "";
                      isSociete = updatedClient.isSociete ?? false;
                    });
                  },
                  openWithCreateClientPage: false, 
                ),
                const SizedBox(height: 12),

                // Appel du widget combo Ecurie
                EcuriesComboCardWidget(
                  ecurieList: ecurieList,
                  selectedEcurie: selectedEcurie,
                  onEcurieChanged: _onEcurieChanged,
                  onAddEcuriePressed: _toggleEcurieCard,
                ),


                // Afficher la ecurieCardWidget si l'état "showEcurieCard" est vrai
                if (showEcurieCard) 
                EcurieCardWidget(
                  idEcurie: idEcurie,
                  initialName: nameEcurie,
                  ownerId: ownerId,
                  adresse: adresseEcurie,
                  onNameChanged: (value) => setState(() => nameEcurie = value),
                  onOwnerIdChanged:(value) => setState(() => ownerId = value),
                  onAdresseChanged: (value) => setState(() => adresseEcurie = value),
                  onSave: _onSaveEcurieCard,
                ),

                const SizedBox(height: 12),

                // Widget pour les informations principales du cheval
                HorseCardWidget(
                  horse: Horse(
                    id: 0,
                    idClient: widget.idClient ?? selectedClient?.idClient ?? 0,  // Utilise idClient si non null, sinon le client sélectionné
                    name: name,
                    ownerId: widget.idClient ?? selectedClient?.idClient ?? 0,
                    race: race,
                    age: age,
                    color: color,
                    feedingType: feedingType,
                    activityType: activityType,
                    lastAppointmentDate: lastAppointmentDate,
                  ),
                  onHorseUpdated: (updatedHorse) {
                    setState(() {
                      name = updatedHorse.name;
                      race = updatedHorse.race;
                      age = updatedHorse.age;
                      color = updatedHorse.color;
                      feedingType = updatedHorse.feedingType;
                      activityType = updatedHorse.activityType;
                      lastAppointmentDate = updatedHorse.lastAppointmentDate;
                    });
                  },
                  openWithCreateHorsePage: true,
                ),
                const SizedBox(height: 12),

                // Widget pour l'adresse et la localisation
                HorseAddressCardWidget(
                  address: horseAddress,
                  location: Location(latitude: latitude, longitude: longitude),
                  onAddressChanged: (newAddress) => setState(() {
                    horseAddress = newAddress;
                  }),
                  openWithCreateHorsePage: true,
                ),
                const SizedBox(height: 12),

                // Widget pour les notes
                NotesCardWidget(
                  initialNotes: notes ?? "",
                  onNotesChanged: (value) => setState(() => notes = value),
                  openWithCreateHorsePage: true,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final newHorse = Horse(
              id: DateTime.now().millisecondsSinceEpoch,
              idClient: widget.idClient ?? selectedClient?.idClient ?? 0,  
              idEcurie: idEcurie,
              name: name,
              ownerId: widget.idClient ?? selectedClient?.idClient ?? 0,
              adresse: horseAddress,
              age: age,
              race: race,
              lastAppointmentDate: lastAppointmentDate,
              color: color,
              feedingType: feedingType,
              activityType: activityType,
              notes: notes,
            );
            Navigator.pop(context, newHorse);
          }
        },
        child: const Icon(Icons.save, color: AppColors.buttonBackgroundColor),
        backgroundColor: Constants.appBarBackgroundColor,
      ),
    );
  }
}

