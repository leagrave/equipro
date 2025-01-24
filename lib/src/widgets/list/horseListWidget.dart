import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:intl/intl.dart'; 
import 'package:equipro/src/models/client.dart'; 
import 'package:go_router/go_router.dart'; 


class HorseListWidget extends StatefulWidget {
  final List<Horse> horses;
  final Function(Horse) onHorseTap;
  final bool isFromListHorsePage; 

  const HorseListWidget({
    Key? key,
    required this.horses,
    required this.onHorseTap,
    this.isFromListHorsePage = false, 
  }) : super(key: key);

  @override
  _HorseListWidgetState createState() => _HorseListWidgetState();
}

class _HorseListWidgetState extends State<HorseListWidget> {
  bool _isExpanded = false;


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

  @override
  void initState() {
    super.initState();
    // Si c'est ouvert depuis ListHorsePage, on étend la liste automatiquement
    if (widget.isFromListHorsePage) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Instance de DateFormat pour le format jj/mm/yyyy
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    // Limite d'affichage des chevaux dans l'état réduit
    final int displayLimit = 3;
    final List<Horse> displayedHorses =
        _isExpanded ? widget.horses : widget.horses.take(displayLimit).toList();

    // Récupération de l'idClient depuis le premier cheval (tous les chevaux doivent appartenir au même client)
    final int? clientId = widget.horses.isNotEmpty ? widget.horses.first.idClient : null;

    return SingleChildScrollView( 
      child: Column(
        children: [
          // Si la liste des chevaux est vide, afficher "Aucun cheval trouvé"
          if (widget.horses.isEmpty)
            Center(
              child: Text(
                "Aucun cheval trouvé",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          else
            // Liste des chevaux (visible uniquement si _isExpanded est vrai)
            if (_isExpanded)
              ListView.builder(
                shrinkWrap: true,
                physics: widget.isFromListHorsePage 
                  ? AlwaysScrollableScrollPhysics() // Permet le défilement si isFromListHorsePage est vrai
                  : NeverScrollableScrollPhysics(), // Empêche le défilement si isFromListHorsePage est faux
                itemCount: widget.horses.length,
                itemBuilder: (context, index) {
                  final horse = widget.horses[index];

                  // Recherche du client correspondant à idClient du cheval
                  final owner = clients.firstWhere(
                    (client) => client.idClient == horse.idClient, 
                    orElse: () => Client(
                      idClient: 0, 
                      nom: 'Inconnu', 
                      prenom: '', 
                      tel: '', 
                      tel2: '', 
                      email: '', 
                      societe: '', 
                      civilite: '', 
                      isSociete: false, 
                      derniereVisite: DateTime.now(),
                      prochaineIntervention: DateTime.now(),
                      adresse: '',
                      adresseFacturation: '',
                      adresses: [],
                      ville: '',
                      notes: ''
                    )
                  );

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            horse.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${horse.age} ans",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),

                      if (widget.isFromListHorsePage)
                        Text(
                          "${owner.prenom} ${owner.nom}",
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    horse.lastAppointmentDate != null
                        ? "Dernière visite : ${dateFormatter.format(horse.lastAppointmentDate!)}"
                        : "Aucune visite",
                    style: TextStyle(
                      color: horse.lastAppointmentDate == null ? Colors.grey : Colors.black,
                    ),
                  ),
  
                  trailing: widget.isFromListHorsePage
                      ? Icon(Icons.arrow_forward_ios, color: Colors.black) 
                      : null,
                  onTap: () {
                    widget.onHorseTap(horse); 
                  },
                ),
              );

                },
              ),
          if (!widget.isFromListHorsePage) 
            Row(
              children: [

                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Constants.white, 
                      ),
                      child: Text(_isExpanded ? "Réduire" : "Voir les chevaux"),
                    ),
                  ),
                ),

                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       _isExpanded = !_isExpanded;
                //     });
                //     if (clientId != null) {
                //       context.go('/listHorse', extra: {'idClient': clientId});
                //     }
                //   },
                //   style: TextButton.styleFrom(
                //     foregroundColor: Constants.white,
                //   ),
                //   child: Text(_isExpanded ? "Voir liste" : ""),
                // ),

              ],
            ),
        ],
      ),
    );
  }

}
