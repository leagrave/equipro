import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/src/pages/horse/managementHorse.dart';
import 'package:equipro/src/pages/horse/createHorse.dart';

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
      name: "Brume",
      ownerId: 3,
      adresse: "123 Rue Principale, Paris",
      age: 6,
      race: "Camarguais",
      lastAppointmentDate: null,
      notes: ""
    ),
  ];

  List<Horse> filteredHorses = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    if (widget.idClient != null) {
      filteredHorses = horses.where((horse) => horse.ownerId == widget.idClient).toList();
    } else {
      filteredHorses = horses;
    }
  }

  void filterHorses(String query) {
    setState(() {
      searchQuery = query;
      filteredHorses = horses.where((horse) {
        return horse.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToManagementHorsePage(Horse horse) async {
    await Navigator.pushNamed(
      context,
      '/managementHorse',
      arguments: horse,
    );
  }

  void navigateToCreateHorsePage() async {
    final newHorse = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateHorsePage()),
    );
    if (newHorse != null) {
      setState(() {
        horses.add(newHorse);
        filteredHorses = horses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyWidgetAppBar(
      //   title: 'Chevaux',
      //   logoPath: 'assets/images/image-logo.jpg',
      //   onNotificationTap: () {
      //     print('Notifications');
      //   },
      //   backgroundColor: AppColors.appBarBackgroundColor,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
              Expanded(
                child: HorseListWidget(
                  horses: filteredHorses,
                  onHorseTap: (horse) {
                    navigateToManagementHorsePage(horse);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateHorsePage,
        backgroundColor: AppColors.appBarBackgroundColor,
        child: const Icon(Icons.add, color: AppColors.buttonBackgroundColor),
      ),
      // bottomNavigationBar: MyWidgetBottomNavBar(
      //   onTap: (index) {
      //     // Navigation selon l'index sélectionné
      //   },
      // ),
    );
  }
}
