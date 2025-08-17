
import 'package:equipro/src/models/intervention.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
import 'package:equipro/src/widgets/card/intervention/horsesComboCardWidget.dart';
import 'package:equipro/src/widgets/card/intervention/interventionCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class CreateInterventionPage extends StatefulWidget {
  final String? userId;
  final String? horseId;
  final String proId;

  const CreateInterventionPage({ 
    this.userId,
    this.horseId,
    required this.proId,
    Key? key,
    }) : super(key: key);

  @override
  _CreateInterventionPageState createState() => _CreateInterventionPageState();
}

class _CreateInterventionPageState extends State<CreateInterventionPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<InterventionCardWidgetState> _interventionCardKey = GlobalKey<InterventionCardWidgetState>();
  final storage = const FlutterSecureStorage();

  List<Users> usersList = [];
  List<Users> filteredUsers = [];
  List<Users> selectedUsers = [];
  bool showDropdown = false;
  bool _isEditing = true;
  bool isLoading = true;
  bool isSaved = false;
  List<Horse> horseList = [];  
  Horse? selectedHorse; 
  List<Horse> horsesUsersList = [];
  String? proID;
  String? token;

  bool showHorseCard = false; 

  Horse newHorse = Horse(
    id: '',
    name: '',
  );


Intervention newIntervention = Intervention(
  id: '', 
  description: 'Soin dentaire',
  careObservation: '',
  interventionDate: DateTime.now(),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  users: Users != null ? [Users(id: '', firstName: '', lastName: '', email: '', professional: false)] : [],
  horse: Horse(id: '', name: ''),
  pro: Users(id: '', firstName: '', lastName: '', email: '', professional: false),
  externalNotes: '',
  incisiveNotes: '',
  mucousNotes: '',
  internalNotes: '',
  otherNotes: '',
  externalObservations: [],
  incisiveObservations: [],
  mucousObservations: [],
  internalObservations: [],
  otherObservations: [],
  invoice: null, 
);

  Future<void> _loadProId() async {
    final storedProId = await storage.read(key: 'user_id');
    final storedToken = await storage.read(key: 'authToken');
    setState(() {
      proID = storedProId;
      token =storedToken;
    });
  }
  
Future<bool> saveIntervention() async {
  try {
    final response = await ApiService.postWithAuth(
      '/intervention',
      {
        "description": newIntervention.description,
        "care_observation": newIntervention.careObservation,
        "intervention_date": newIntervention.interventionDate?.toIso8601String(),
        "users": selectedUsers.map((u) => u.id).toList(),
        "horse_id": selectedHorse!.id,
        "pro_id": proID,
        "external_notes": newIntervention.externalNotes,
        "incisive_notes": newIntervention.incisiveNotes,
        "mucous_notes": newIntervention.mucousNotes,
        "internal_notes": newIntervention.internalNotes,
        "other_notes": newIntervention.otherNotes,
        "external_observations": newIntervention.externalObservations?.map((b) => b.id).toList() ?? [],
        "incisive_observations": newIntervention.incisiveObservations?.map((b) => b.id).toList() ?? [],
        "mucous_observations": newIntervention.mucousObservations?.map((b) => b.id).toList() ?? [],
        "internal_observations": newIntervention.internalObservations?.map((b) => b.id).toList() ?? [],
        "other_observations": newIntervention.otherObservations?.map((b) => b.id).toList() ?? [],
      },
    );

    if (response.statusCode == 201) {
      //Navigator.pop(context, newIntervention);
      
      final data = jsonDecode(response.body);
      final newId = data['id']; 

      newIntervention.id = newId;

      return true;
    } else {
      print("Erreur lors de la création de l'intervention: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Erreur globale dans saveIntervention: $e");
    return false;
  }
}


void _onClientSelected(Users? user) async {
  if (user == null) return;

  final alreadyExists = selectedUsers.any((u) => u.id == user.id);
  if (!alreadyExists) {
    setState(() {
      selectedUsers.add(user);
      newIntervention = newIntervention.copyWith(users: selectedUsers);
      showDropdown = false;
    });

    // Récupérer les chevaux pour la nouvelle liste d'utilisateurs sélectionnés
    final selectedIds = selectedUsers
        .where((u) => u.id != null)
        .map((u) => u.id!)
        .toList();

    final horses = await fetchHorses(selectedIds);

    setState(() {
      horseList = horses;
    });

  } else {
    setState(() {
      showDropdown = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${user.firstName} ${user.lastName} est déjà sélectionné."),
        duration: Duration(seconds: 2),
      ),
    );
  }
}




void _onRemoveUser(Users user) async {
  setState(() {
    selectedUsers.removeWhere((u) => u.id == user.id);
  });

  // Relancer le fetch des chevaux après la suppression
  final selectedIds = selectedUsers
      .where((u) => u.id != null)
      .map((u) => u.id!)
      .toList();

  final horses = await fetchHorses(selectedIds);

  setState(() {
    horseList = horses;
  });
}



  void _onAddClientPressed(String? newClientId) async {
    if (newClientId != null) {
      List<Users> newUsers = await fetchClients();
      final newUser = newUsers.firstWhere((u) => u.id == newClientId, );

      setState(() {
        usersList = newUsers;
        if (newUser.id != null) selectedUsers.add(newUser);
        showDropdown = false;
      });
    } else {
      setState(() {
        showDropdown = true;
      });
    }
  }

  void _onDropdownCancel() {
    setState(() {
      showDropdown = false;
    });
  }



  Future<List<Users>> fetchClients() async {
    print(proID);
    try {
      final response = await ApiService.getWithAuth("/agendaAll/$proID");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final fetchedClients = jsonData.map((data) => Users.fromJson(data)).toList();
        return List<Users>.from(fetchedClients);
      } else {
        throw Exception("Échec du chargement des clients");
      }
    } catch (e) {
      print("Erreur lors du fetch des clients : $e");
      return [];
    }
  }


Future<List<Horse>> fetchHorses(List<String> userIds) async {
  //print(userIds);
  try {
    final response = await ApiService.postWithAuth(
      '/horses/users',
      {
        "userIds": userIds,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Horse.fromJson(data)).toList();
    } else {
      throw Exception("Échec du chargement des chevaux");
    }
  } catch (e) {
    print("Erreur lors du fetch des chevaux : $e");
    return [];
  }
}



Future<void> loadClientsAndHorses() async {
  try {
    setState(() {
      isLoading = true;
    });

    // Charger tous les clients liés au pro
    final clients = await fetchClients();

    setState(() {
      usersList = clients;
    });

    //Pré-sélectionner un utilisateur si `widget.userId` est fourni
    if (widget.userId != null) {
      final preselectedUser = clients.firstWhere(
        (user) => user.id == widget.userId,
        orElse: () => clients.first,
      );

      if (preselectedUser.id != null) {
        setState(() {
          selectedUsers = [preselectedUser]; 
        });
      }
    }

    // Charger les chevaux associés aux utilisateurs sélectionnés
    if (selectedUsers.isNotEmpty) {
      final selectedIds = selectedUsers
          .where((u) => u.id != null)
          .map((u) => u.id!)
          .toList();

      final horses = await fetchHorses(selectedIds);
      //print("Chevaux chargés pour les utilisateurs sélectionnés : $horses");

      setState(() {
        horseList = horses;
      });
    }

  } catch (e) {
    print("Erreur lors du chargement des clients et chevaux : $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}



@override
void initState() {
  super.initState();
  _init();
}

Future<void> _init() async {
  await _loadProId();
  await loadClientsAndHorses();
}



  void _onHorseChanged(Horse? newHorse) async {
    setState(() {
      selectedHorse = newHorse;
      newHorse = newHorse?.copyWith(
        id: newHorse?.id,
        name: newHorse?.name,
      );
    });
  }


  void _toggleHorseCard() {
    setState(() {
      showHorseCard = !showHorseCard;  
    });
  }

  // void _onSaveEcurieCard() {
  //   setState(() {
  //     showHorseCard = false;  
  //   });
  // }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Créer une intervention',
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Appel du widget combo Client
                  ClientsComboCardWidget(
                    proID: widget.proId,
                    userList: usersList,
                    selectedUsers: selectedUsers,
                    showDropdown: showDropdown,
                    onClientSelected: _onClientSelected,
                    onAddClientPressed: _onAddClientPressed,
                    onDropdownCancel: _onDropdownCancel,
                    onRemoveUser: _onRemoveUser,
                    isEditing : _isEditing,
                  ),

                  // Appel du widget combo Ecurie
                  HorsesComboCardWidget(
                    horseList: horseList,
                    selectedHorse: selectedHorse,
                    onHorseChanged: _onHorseChanged,
                    onAddHorsePressed: _toggleHorseCard,
                    isEditing : _isEditing,
                  ),

                  // // Widget pour les informations principales du cheval
                  InterventionCardWidget(
                    key: _interventionCardKey,
                    intervention: newIntervention,
                    onInterventionUpdated: (updatedIntervention) {
                      setState(() {
                        newIntervention = newIntervention.copyWith(
                          description: updatedIntervention.description,
                          careObservation: updatedIntervention.careObservation,
                          interventionDate: updatedIntervention.interventionDate,
                          externalNotes: updatedIntervention.externalNotes,
                          incisiveNotes: updatedIntervention.incisiveNotes,
                          mucousNotes: updatedIntervention.mucousNotes,
                          internalNotes: updatedIntervention.internalNotes,
                          otherNotes: updatedIntervention.otherNotes,
                          externalObservations: updatedIntervention.externalObservations,
                          incisiveObservations: updatedIntervention.incisiveObservations,
                          mucousObservations: updatedIntervention.mucousObservations,
                          internalObservations: updatedIntervention.internalObservations,
                          otherObservations: updatedIntervention.otherObservations,
                        );
                      });
                    },
                    openWithCreateInterventionPage: true,
                    isEditing: true,
                    proID: widget.proId,
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isValid = await _interventionCardKey.currentState!.validateForm();
            if (!isValid) return; 

          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            bool success = await saveIntervention();
            if (success) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Intervention enregistrée'),
                    content: const Text('Voulez-vous créer une facture ?'),
                    actions: [
                      TextButton(
                        child: const Text('Non'),
                        onPressed: () {
                          Navigator.pop(context); 
                          Navigator.pop(context, newIntervention); 
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Oui'),
                        onPressed: () {
                          Navigator.pop(context); 
                          context.push('/createInvoice', extra: {
                            'intervention': newIntervention,
                            'proID': proID,
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erreur lors de la sauvegarde de l\'intervention.')),
              );
            }
          }
        },
        child: const Icon(Icons.save, color: Constants.appBarBackgroundColor),
        backgroundColor: Constants.turquoiseDark,
      ),

    );
  }
}


