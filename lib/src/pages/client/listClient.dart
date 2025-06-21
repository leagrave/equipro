import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/widgets/list/clientListWidget.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ListClientPage extends StatefulWidget {
  final String? userId;

  const ListClientPage({Key? key, this.userId}) : super(key: key);

  @override
  _ListClientPageState createState() => _ListClientPageState();
}

class _ListClientPageState extends State<ListClientPage> {
  List<User> users = [];
  List<User> filteredUsers = [];
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
      final response = await http.get(Uri.parse("${Constants.apiBaseUrl}/agenda/${widget.userId}"));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final fetchedClients = jsonData.map((data) => User.fromJson(data)).toList();

        setState(() {
          users = List<User>.from(fetchedClients);
          // On met filteredUsers égal à tous les clients récupérés (contacts du user)
          filteredUsers = users;
          isLoading = false;
        });

        print("filteredUsers.length = ${filteredUsers.length}");
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


  void filterClients(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = users.where((user) {
        final fullName = "${user.lastName} ${user.firstName}".toLowerCase();
        // final fullTel = "${user.tel}".toLowerCase();
        // final cityRegion = "${client.ville} ${client.region ?? ''}".toLowerCase();

        return fullName.contains(query.toLowerCase());
            // cityRegion.contains(query.toLowerCase()) ||
            // fullTel.contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToManagementClientPage(User user) {
    context.push('/managementClient', extra: user);
  }

  void navigateToCreateClientPage() async {
    final newClient = await context.push('/createClient');
    if (newClient != null && newClient is User) {
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
                          hintText: "Rechercher par nom, prénom, tel ou ville",
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
