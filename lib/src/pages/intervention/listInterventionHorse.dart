
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:equipro/src/models/intervention.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HorseInterventionListWidget extends StatefulWidget {
  final String? userId;
  final String? horseId;
  final String proID;

  const HorseInterventionListWidget({
    Key? key,
    this.userId,
    this.horseId,
    required this.proID,
  }) : super(key: key);

  @override
  State<HorseInterventionListWidget> createState() =>
      _HorseInterventionListWidgetState();
}

class _HorseInterventionListWidgetState extends State<HorseInterventionListWidget> {
  List<Intervention> interventions = [];
  bool isLoading = true;
  String _searchQuery = '';
  final TextEditingController _controller = TextEditingController();

  Horse? currentHorse;
  List<Users> users = [];


  @override
  void initState() {
    super.initState();
      loadAllData();
    fetchInterventions();
  }

  Future<void> loadAllData() async {
  setState(() => isLoading = true);


  await fetchInterventions();

  setState(() => isLoading = false);
}



  Future<void> fetchInterventions() async {
    if (widget.horseId == null && widget.userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final url = widget.horseId != null
          ? "${Constants.apiBaseUrl}/interventions/horse/${widget.horseId}"
          : "${Constants.apiBaseUrl}/interventions/user/${widget.userId}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          interventions = data
              .map((json) => Intervention.fromJson(json))
              .where((i) => i.interventionDate != null)
              .toList()
            ..sort((a, b) => b.interventionDate!.compareTo(a.interventionDate!));
          isLoading = false;
        });
      } else {
        throw Exception('Erreur serveur');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors du chargement des interventions")),
      );
    }
  }



  void navigateToCreateInterventionPage() async {
    await context.push('/createIntervention', extra: {
      'proID': widget.proID,
      'userId': widget.userId,
      'horseId': widget.horseId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    final filteredList = interventions.where((intervention) {
      final query = _searchQuery.toLowerCase();
      final horseName = intervention.horse?.name.toLowerCase() ?? '';
      final description = intervention.description?.toLowerCase() ?? '';
      final dateStr = intervention.interventionDate != null
          ? dateFormatter.format(intervention.interventionDate!)
          : '';
      return horseName.contains(query) ||
          description.contains(query) ||
          dateStr.contains(query);
    }).toList();

    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Interventions',
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.horseId == null && widget.userId == null
                ? const Center(
                    child: Text(
                      "Aucun identifiant fourni.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Rechercher (cheval, date)',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: filteredList.isEmpty
                            ? const Center(
                                child: Text(
                                  "Aucune intervention trouvée.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final intervention = filteredList[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      title: Text(intervention.description ??
                                          "Sans description"),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Cheval : ${intervention.horse?.name ?? 'Non spécifié'}"),
                                          if (intervention.interventionDate != null)
                                            Text("Date : ${dateFormatter.format(intervention.interventionDate!)}"),
                                        ],
                                      ),
                                      leading: const Icon(Icons.healing),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateInterventionPage,
        backgroundColor: Constants.turquoiseDark,
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
