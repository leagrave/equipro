import 'package:equipro/src/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/widgets/list/clientListWidget.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diacritic/diacritic.dart';

class ListClientPage extends StatefulWidget {
  final String? userId;

  const ListClientPage({Key? key, this.userId}) : super(key: key);

  @override
  _ListClientPageState createState() => _ListClientPageState();
}

class _ListClientPageState extends State<ListClientPage> {
  List<Users> users = [];
  List<Users> filteredUsers = [];
  List<Horse> horses = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

Future<void> fetchClients() async {
  try {

    // Effectuer la requête avec Authorization: Bearer <token>
    final response = await ApiService.getWithAuth("/agendaAll/${widget.userId}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final fetchedClients = jsonData.map((data) => Users.fromJson(data)).toList();

      setState(() {
        users = List<Users>.from(fetchedClients);
        filteredUsers = users;
        isLoading = false;
      });
    } 
    else if (response.statusCode == 401) {
      // Token invalide ou expiré
      throw Exception("Session expirée. Veuillez vous reconnecter.");
    }
    else {
      throw Exception("Échec du chargement des clients (code ${response.statusCode})");
    }
  } catch (e) {
    print("Erreur lors du fetch des clients : $e");
    setState(() {
      isLoading = false;
    });
  }
}



void filterClients(String query) {
  setState(() {
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    filteredUsers = users.where((user) {
      final fullName = removeDiacritics("${user.lastName} ${user.firstName}".toLowerCase());
      final fullTel = removeDiacritics("${user.phone}".toLowerCase());

      String city = '';

      // Cherche en priorité la ville de l'adresse principale
      if (user.addresses != null) {
        Address? mainAddress;
        Address? billingAddress;

        for (final addr in user.addresses!) {
          if (addr.type == 'main') {
            mainAddress = addr;
            break;
          } else if (addr.type == 'billing') {
            billingAddress = addr;
          }
        }

        city = removeDiacritics((mainAddress ?? billingAddress)?.city?.toLowerCase() ?? '');
      }

      final horseMatch = user.horses?.any((horse) =>
        removeDiacritics(horse.name.toLowerCase()).contains(normalizedQuery)
      ) ?? false;

      return fullName.contains(normalizedQuery) ||
          fullTel.contains(normalizedQuery) ||
          city.contains(normalizedQuery) ||
          horseMatch;
    }).toList();
  });
}




  void navigateToManagementClientPage(Users user) {
    context.push('/managementClient', extra: {
            'userSelected': user,
            'currentUserId': widget.userId,
          });
  }

  void navigateToCreateClientPage() async {
    final newClient = await context.push('/createClient', extra: {
      'proID': widget.userId ,
      'openWithCreateHorsePage': false,
    });
    if (newClient != null && newClient is Users) {
      setState(() {
        users.add(newClient);
        filteredUsers = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                    // Recherche
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
                          hintText: "Rechercher par nom, prénom, tel, ville ou cheval",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Liste
                    Expanded(
                      child: ClientListWidget(
                        currentUserId: widget.userId,
                        filteredUsers: filteredUsers,
                        onClientTap: navigateToManagementClientPage,
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
