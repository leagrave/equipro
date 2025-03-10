import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:go_router/go_router.dart';

class ListHorsePage extends StatefulWidget {
  final int? idClient;

  const ListHorsePage({Key? key, this.idClient}) : super(key: key);

  @override
  _ListHorsePageState createState() => _ListHorsePageState();
}

class _ListHorsePageState extends State<ListHorsePage> {
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

  
  List<Horse> filteredHorses = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (widget.idClient != null) {
      // Si idClient est non nul, on filtre les chevaux selon l'idClient
      filteredHorses = horses.where((horse) => horse.idClient == widget.idClient).toList();
    } else {
      // Sinon, on affiche tous les chevaux
      filteredHorses = horses;
    }
  }

    void filterHorses(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredHorses = horses; // Si la recherche est vide, on affiche tous les chevaux
      } else {
        filteredHorses = horses.where((horse) {
          return horse.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void navigateToManagementHorsePage(Horse horse) async {
    context.push('/managementHorse',extra: horse);
  }

  void navigateToCreateHorsePage() async {
    final newHorse = await context.push('/createHorse',extra: {'idClient': widget.idClient},);
    if (newHorse != null && newHorse is Horse) {
      setState(() {
        horses.add(newHorse);
        filteredHorses = widget.idClient != null
            ? horses.where((horse) => horse.idClient == widget.idClient).toList()
            : horses;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Mes Chevaux',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.appBarBackgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                  onChanged: filterHorses,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)),
                    hintText: "Rechercher un cheval par nom",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Text(
              //   "Liste des chevaux de ${widget.idClient ?? 'inconnu'}",
              //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              // ),


              Expanded(
                child: HorseListWidget(
                  horses: filteredHorses,
                  onHorseTap: (horse) {
                    navigateToManagementHorsePage(horse);
                  },
                  isFromListHorsePage: true, 
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateHorsePage,
        backgroundColor: Constants.turquoiseDark,
        child: const Icon(Icons.add, color: AppColors.buttonBackgroundColor),
      ),
    );
  }
}
