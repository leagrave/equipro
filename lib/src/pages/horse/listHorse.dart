import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/widgets/list/horseListWidget.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListHorsePage extends StatefulWidget {
  final String proID;
  final String? customer_id;
  final String? userCustomerID;

  const ListHorsePage({Key? key,required this.proID, this.customer_id, this.userCustomerID}) : super(key: key);

  @override
  _ListHorsePageState createState() => _ListHorsePageState();
}

class _ListHorsePageState extends State<ListHorsePage> {
  List<Horse> horses = [];
  bool isLoading = true;
  
  List<Horse> filteredHorses = [];
  String searchQuery = "";


  Future<void> fetchHorses() async {
    try {
      final response = await ApiService.getWithAuth("/horses/user/${widget.userCustomerID}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final fetchedHorses = jsonData.map((data) => Horse.fromJson(data)).toList();

        setState(() {
          horses = List<Horse>.from(fetchedHorses);
          // On met filteredUsers égal à tous les clients récupérés (contacts du user)
          filteredHorses = horses;
          isLoading = false;
        });

      } else {
        throw Exception("Échec du chargement des clients");
      }
    } catch (e) {
      print("Erreur lors du fetch des clients : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAllHorses() async {
    try {
      final response = await ApiService.getWithAuth("/horses");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final fetchedHorses = jsonData.map((data) => Horse.fromJson(data)).toList();

        setState(() {
          horses = List<Horse>.from(fetchedHorses);
          // On met filteredUsers égal à tous les clients récupérés (contacts du user)
          filteredHorses = horses;
          isLoading = false;
        });

      } else {
        throw Exception("Échec du chargement des clients");
      }
    } catch (e) {
      print("Erreur lors du fetch des clients : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.userCustomerID != null) {
      // On filtre les chevaux dont la liste users contient ce customer_id
      fetchHorses();
      filteredHorses = horses.where((horse) {
        return horse.users!.any((user) => user.id == widget.userCustomerID);
      }).toList();
    } else {
      fetchAllHorses();
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

  void navigateToManagementHorsePage(String horseId) async {
    context.push('/managementHorse', extra: {
      'horseId': horseId,
      'proID': widget.proID,
    });
  }

  void navigateToCreateHorsePage() async {
    final newHorse = 
    await context.push('/createHorse', extra: {
      'proID': widget.proID,
      'userCustomId': widget.userCustomerID
    });
    if (newHorse != null && newHorse is Horse) {
      setState(() {
        horses.add(newHorse);
        filteredHorses = widget.userCustomerID != null
            ? horses.where((horse) {
                return horse.users!.any((user) => user.id == widget.userCustomerID);
              }).toList()
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
            colors: Constants.gradientBackground,
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
                    navigateToManagementHorsePage(horse.id);
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
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
