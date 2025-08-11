import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
import 'package:equipro/src/widgets/card/ecurie/ecurieCardWidget.dart';
import 'package:equipro/src/widgets/card/ecurie/ecuriesComboCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/customer.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/models/ecurie.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/widgets/card/horse/horseAdresseCardWidget.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/horse/horseCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/horse/listBottumHorseCardWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';


class ManagementHorsePage extends StatefulWidget {
  final String horseId;
  final String proID;

  const ManagementHorsePage({Key? key, required this.horseId, required this.proID}) : super(key: key);

  @override
  _ManagementHorsePageState createState() => _ManagementHorsePageState();
}

class _ManagementHorsePageState extends State<ManagementHorsePage> {

  bool _isEditing = false;
  bool showClientCard = false;
  bool showEcurieCard = false;
  List<Users> usersList = [];
  List<Users> filteredUsers = [];
  List<Users> selectedUsers = [];
  bool showDropdown = false;
  bool isSaved = false;
  bool isLoading = true;

  List<Ecurie> ecurieList = [];  
  Ecurie? selectedEcurie; 
  Ecurie? newEcurie;

  String? selectedEcurieId;

  bool isLoadingHorse = true;


  String horseNotes = '';

  Horse newHorse = Horse(
    id: '',
    name: '',
    age: 0,
    stableId: null,
    lastVisitDate: null,
    nextVisitDate: null,
    notes: null,
    users: [],
    breeds: [],
    feedTypes: [],
    colors: [],
    activityTypes: [],
    address: [],
  );

void _onClientSelected(Users? user) {
  if (user == null) return;

  final alreadyExists = selectedUsers.any((u) => u.id == user.id);
  if (!alreadyExists) {
    setState(() {
      selectedUsers.add(user);
      newHorse = newHorse.copyWith(users: selectedUsers);
      showDropdown = false;
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

  Future<List<Users>> fetchClients() async {
    try {
      final response = await ApiService.getWithAuth("/agendaAll/${widget.proID}");
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

Future<List<Ecurie>> fetchEcuries() async {
  try {
    final response = await ApiService.getWithAuth("/stables/owner/${widget.proID}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Ecurie.fromJson(data)).toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de charger les écuries.")),
      );
      return [];
    }
  } catch (e) {
    print("Erreur lors du fetch des écuries : $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Une erreur est survenue pendant le chargement des écuries.")),
    );
    return [];
  }
}

Future<bool> updateHorseStableId(String horseId, String newStableId) async {
  try {
    final response = await ApiService.putWithAuth(
      '/horse/$horseId/stable',
      {
        "stableId": newStableId,
      },
    );

    if (response.statusCode == 200) {
      print("StableId mis à jour avec succès");
      return true;
    } else {
      print("Erreur lors de la mise à jour du stableId : ${response.body}");
      return false;
    }
  } catch (e) {
    print("Exception lors de la mise à jour du stableId : $e");
    return false;
  }
}


Future<Horse?> fetchHorseById(String horseId) async {
  try {
    final response = await ApiService.getWithAuth("/horse/by-id/$horseId");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Horse.fromJson(jsonData);
    } else {
      print("Erreur lors de la récupération du cheval : ${response.body}");
      return null;
    }
  } catch (e) {
    print("Exception lors du fetch du cheval : $e");
    return null;
  }
}

Future<bool> updateHorseUsers(String horseId, List<Users> selectedUsers) async {
  final userIds = selectedUsers.map((u) => u.id).toList();

  try {
    final response = await ApiService.putWithAuth(
      '/horse/$horseId/users',
      {'userIds': userIds},
    );

    if (response.statusCode == 200) {
      print('Mise à jour réussie');
      return true;
    } else {
      print('Erreur mise à jour users: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exception lors de la mise à jour users: $e');
    return false;
  }
}





  @override
  void initState() {
    super.initState();
    _loadFullHorse();
    _loadEcuries();
    _loadClients();

      // Préparer une nouvelle écurie vide (si besoin de création)
      newEcurie = Ecurie(id: '', name: '', user_id: '', addressId: null, phone: null, phone2: null);

  }

void _loadFullHorse() async {
  final fullHorse = await fetchHorseById(widget.horseId);

  setState(() {
    if (fullHorse != null) {
      newHorse = fullHorse;
      selectedUsers = List<Users>.from(fullHorse.users ?? []);

      if (fullHorse.stableId != null) {
        selectedEcurie = ecurieList.firstWhere(
          (e) => e.id == fullHorse.stableId,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de chargement du cheval.")),
      );
    }
    isLoadingHorse = false; // toujours le passer à false
  });

  //print("Cheval chargé : ${fullHorse?.name}");
}


void _loadClients() async {
  final fetched = await fetchClients();
  setState(() {
    usersList = fetched;
    isLoading = false;
  });
}


  void _loadEcuries({String? stableId}) async {
    final fetchedEcuries = await fetchEcuries();

    setState(() {
      ecurieList = fetchedEcuries;
      if (stableId != null) {
        selectedEcurie = fetchedEcuries.firstWhere(
          (e) => e.id == stableId,
          orElse: () => Ecurie(id: '', name: '', user_id: '', addressId: null),
        );
      }
    });
  }

Future<List<Address>> fetchAddressById(String id) async {
  try {
    final response = await ApiService.getWithAuth("/address/$id");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is List && jsonData.isNotEmpty) {
        return [Address.fromJson(jsonData[0])];
      } else {
        return [];
      }
    } else {
      throw Exception('Échec de récupération de l\'adresse');
    }
  } catch (e) {
    print("Erreur lors du fetch de l'adresse : $e");
    return [];
  }
}


  void _onEcurieChanged(Ecurie? newEcurie) async {
    setState(() {
      selectedEcurie = newEcurie;
      newHorse = newHorse.copyWith(
        stableId: newEcurie?.id,
        address: [], 
      );
    });

    if (newEcurie != null && newEcurie.addressId != null) {
      final fetchedAddress = await fetchAddressById(newEcurie.addressId!);
      if (fetchedAddress.isNotEmpty) {
        setState(() {
          newHorse = newHorse.copyWith(address: fetchedAddress);
        });
      }
    }
  }


  void _toggleClientCard() {
    setState(() {
      showClientCard = !showClientCard;
    });
  }

  void _toggleEcurieCard() {
    setState(() {
      showEcurieCard = !showEcurieCard;
    });
  }

  void _onDropdownCancel() {
    setState(() {
      showDropdown = false;
    });
  }

  void _onRemoveUser(Users user) {
    setState(() {
      selectedUsers.removeWhere((u) => u.id == user.id);
    });
  }

  void _onSaveEcurieCard() {
    setState(() {
      showEcurieCard = false;  
    });
  }

void _setEditing(bool value) {
  setState(() {
    _isEditing = value;

  });
}

void _onSaveStateChanged(bool saved) async {
  setState(() {
    isSaved = saved;
  });

  if (saved) {
    // Mise à jour de l'écurie si besoin
    if (selectedEcurie != null && selectedEcurie!.id != newHorse.stableId) {
      bool success = await updateHorseStableId(newHorse.id, selectedEcurie!.id);
      if (success) {
        setState(() {
          newHorse = newHorse.copyWith(stableId: selectedEcurie!.id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la mise à jour de l'écurie.")),
        );
      }
    }

    // Mise à jour des utilisateurs/propriétaires si besoin
    final currentIds = (newHorse.users ?? []).map((u) => u.id).toSet();
    final newIds = selectedUsers.map((u) => u.id).toSet();

    if (!setEquals(currentIds, newIds)) {
      bool success = await updateHorseUsers(newHorse.id, selectedUsers);
      if (success) {
        setState(() {
          newHorse = newHorse.copyWith(users: List<Users>.from(selectedUsers));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la mise à jour des propriétaires.")),
        );
      }
    }
  }

  print("Le cheval a été ${saved ? "sauvegardé" : "annulé"}");
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Gestion cheval',
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
            child: Column(
              children: [
                if (usersList.isNotEmpty)
                ClientsComboCardWidget(
                  proID: widget.proID,
                  userList: usersList,
                  selectedUsers: selectedUsers,
                  showDropdown: showDropdown,
                  onClientSelected: _onClientSelected,
                  onAddClientPressed: _onAddClientPressed,
                  onDropdownCancel: _onDropdownCancel,
                  onRemoveUser: _onRemoveUser,
                  isEditing : _isEditing,
                ),

                // Widget combo Ecurie
                if (ecurieList.isNotEmpty)
                EcuriesComboCardWidget(
                  ecurieList: ecurieList,
                  selectedEcurie: selectedEcurie,
                  onEcurieChanged: _onEcurieChanged,
                  onAddEcuriePressed: _toggleEcurieCard,
                  isEditing : _isEditing,
                ),

                // Affichage conditionnel EcurieCardWidget
                if (showEcurieCard && newEcurie != null)
                  EcurieCardWidget(
                    proID: widget.proID,
                    ecurie: newEcurie!,
                    onUpdated: (updatedEcurie) {
                      setState(() {
                        newEcurie = updatedEcurie;
                      });
                    },
                    onSave: _onSaveEcurieCard,
                    openWithCreateHorsePage: true,
                  ),

                const SizedBox(height: 16),

                // Gestion du chargement du cheval
                if (isLoadingHorse)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  HorseCardWidget(
                    horse: newHorse,
                    onHorseUpdated: (updatedHorse) {
                      setState(() {
                        newHorse = newHorse.copyWith(
                          name: updatedHorse.name,
                          age: updatedHorse.age,
                          stableId: updatedHorse.stableId,
                          breeds: updatedHorse.breeds,
                          colors: updatedHorse.colors,
                          feedTypes: updatedHorse.feedTypes,
                          activityTypes: updatedHorse.activityTypes,
                        );
                      });
                    },
                    openWithCreateHorsePage: false,
                    isEditing: _isEditing,
                    onEditingChanged: _setEditing, 
                    onSaveStateChanged: _onSaveStateChanged,
                  ),

                  const SizedBox(height: 16),

                  AddressCardWidget(
                    //key: ValueKey(newHorse.address?.firstOrNull?.idAddress ?? 'default'),
                    addresses: newHorse.address ?? [],
                    userSelectedId: null,
                    onAdresseChanged: (updatedAddresses) {
                      setState(() {
                        newHorse = newHorse.copyWith(
                          address: updatedAddresses.isEmpty ? null : updatedAddresses,
                        );
                      });
                    },
                    openWithCreateHorsePage: false,
                    openWithCreateClientPage: false,
                    openWithManagementHorsePage: true,
                    horseSelectedId: newHorse.id,
                  ),

                  const SizedBox(height: 16),

                  NotesCardWidget(
                    initialNotes: newHorse.notes ?? '',
                    onNotesChanged: (value) => setState(() {
                      horseNotes = value;
                      newHorse = newHorse.copyWith(notes: value);
                    }),
                    openWithCreateHorsePage: false,
                    openWithCreateClientPage: false,
                    openWithManagementHorsePage: true,
                    visitId: null,
                    proID: widget.proID,
                    customId: null,
                    horseId: newHorse.id,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}