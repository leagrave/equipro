
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:equipro/src/models/intervention.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HorseInterventionListWidget extends StatefulWidget {
  final String? userId;
  final String? horseId;
  final String proID;
  final String? userCustomID;

  const HorseInterventionListWidget({
    Key? key,
    this.userId,
    this.horseId,
    required this.proID,
    this.userCustomID,
  }) : super(key: key);

  @override
  State<HorseInterventionListWidget> createState() =>
      _HorseInterventionListWidgetState();
}

class _HorseInterventionListWidgetState extends State<HorseInterventionListWidget> {
  List<Intervention> interventions = [];
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  String _searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  String? proId;
  Horse? currentHorse;
  List<Users> users = [];


@override
void initState() {
  super.initState();
  _initData();
}

Future<void> _initData() async {
  setState(() => isLoading = true);

  await _loadProId();

  await fetchInterventions();

  setState(() => isLoading = false);
}

//   Future<void> loadAllData() async {
//   setState(() => isLoading = true);


//   await fetchInterventions();

//   setState(() => isLoading = false);
// }

  Future<void> _loadProId() async {
    final storedProId = await storage.read(key: 'pro_id');
    setState(() {
      proId = storedProId;
    });
  }




Future<void> fetchInterventions() async {
  if (widget.horseId == null && widget.userId == null) {
    setState(() {
      isLoading = false;
    });
    return;
  }

  try {
    final endpoint = widget.horseId != null
        ? '/interventions/horse/${widget.horseId}'
        : '/interventions/user/${widget.userId}';

    final response = await ApiService.getWithAuth(endpoint);

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
        debugPrint('Erreur serveur: ${response.statusCode} - ${response.body}');
        throw Exception('Erreur serveur');
      }
        } catch (e, stackTrace) {
    debugPrint('Erreur: $e');
    debugPrint('Stack: $stackTrace');
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erreur lors du chargement des interventions")),
    );
  }
  // } catch (e) {
  //   setState(() => isLoading = false);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Erreur lors du chargement des interventions")),
  //   );
  // }
}



  void navigateToCreateInterventionPage() async {
    await context.push('/createIntervention', extra: {
      'proId': widget.proID,
      'userId': widget.userId,
      'horseId': widget.horseId,
    });
    fetchInterventions();
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
