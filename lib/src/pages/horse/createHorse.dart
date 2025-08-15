import 'package:equipro/src/models/ecurie.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
import 'package:equipro/src/widgets/card/ecurie/ecurieCardWidget.dart';
import 'package:equipro/src/widgets/card/ecurie/ecuriesComboCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/horse/horseCardWidget.dart';
import 'package:equipro/src/models/customer.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateHorsePage extends StatefulWidget {
  final String proID;
  final Users? customer;
  final String? userCustomId;

  const CreateHorsePage({ this.customer,required this.proID, this.userCustomId, Key? key}) : super(key: key);

  @override
  _CreateHorsePageState createState() => _CreateHorsePageState();
}

class _CreateHorsePageState extends State<CreateHorsePage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<HorseCardWidgetState> _horseCardKey = GlobalKey<HorseCardWidgetState>();

  List<Users> usersList = [];
  List<Users> filteredUsers = [];
  List<Users> selectedUsers = [];
  bool showDropdown = false;
  bool _isEditing = true;
  bool isLoading = true;
  bool isSaved = false;
  List<Ecurie> ecurieList = [];  
  Ecurie? selectedEcurie; 
  Ecurie? newEcurie;

  bool showEcurieCard = false; 
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
  
Future<bool> saveHorse() async {
  try {
    final response = await ApiService.postWithAuth(
      '/horse',
      {
        "horse": {
          'name': newHorse.name,
          'age': newHorse.age,
          'stable_id': newHorse.stableId,
          'last_visit_date': null,
          'next_visit_date': null,
          'notes': newHorse.notes,
          'breed_ids': newHorse.breeds?.map((b) => b.id).toList() ?? [],
          'color_ids': newHorse.colors?.map((c) => c.id).toList() ?? [],
          'feed_type_ids': newHorse.feedTypes?.map((f) => f.id).toList() ?? [],
          'activity_type_ids': newHorse.activityTypes?.map((a) => a.id).toList() ?? [],
        },
        "address": (newHorse.address != null && newHorse.address!.isNotEmpty)
            ? {
                "address": newHorse.address!.first.address,
                "city": newHorse.address!.first.city,
                "postal_code": newHorse.address!.first.postalCode,
                "country": newHorse.address!.first.country,
                "latitude": newHorse.address!.first.latitude,
                "longitude": newHorse.address!.first.longitude,
                "user_id": null,
                "horse_id": null,
                "type": "main",
              }
            : null,
        'users': selectedUsers.map((u) => u.id).toList(),
      },
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, newHorse);
      return true;
    } else {
      print("Erreur lors de la création du client: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Erreur globale dans saveClient: $e");
    return false;
  }
}


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



  void _onRemoveUser(Users user) {
    setState(() {
      selectedUsers.removeWhere((u) => u.id == user.id);
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
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucune écurie trouvée.")),
      );
      return [];
    }
    else {
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




  Future<void> _loadClients() async {
    final users = await fetchClients();
    setState(() {
      usersList = users;
      isLoading = false;
    });

    if (widget.userCustomId != null) {
      final preselected = usersList.firstWhere(
        (user) => user.id == widget.userCustomId,
      );
      if (preselected.id != null) {
        setState(() {
          selectedUsers.add(preselected);
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _loadEcruries();
    _loadClients();

    newEcurie = Ecurie(id: '', name: '', user_id: '', addressId: null, phone: null, phone2: null);

  }

  void _loadEcruries() async {
    final fetchedEcuries = await fetchEcuries();

    setState(() {
      ecurieList = fetchedEcuries;
    });
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


  void _toggleEcurieCard() {
    setState(() {
      showEcurieCard = !showEcurieCard;  
    });
  }

  void _onSaveEcurieCard() {
    setState(() {
      showEcurieCard = false;  
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Créer un cheval',
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

                  // Appel du widget combo Ecurie
                  EcuriesComboCardWidget(
                    ecurieList: ecurieList,
                    selectedEcurie: selectedEcurie,
                    onEcurieChanged: _onEcurieChanged,
                    onAddEcuriePressed: _toggleEcurieCard,
                    isEditing : _isEditing,
                  ),


                  // Afficher la ecurieCardWidget si l'état "showEcurieCard" est vrai
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

                  // // Widget pour les informations principales du cheval
                  HorseCardWidget(
                    key: _horseCardKey,
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
                    openWithCreateHorsePage: true,
                    isEditing: true,
                  ),

                  const SizedBox(height: 16),

                  // Widget pour l'adresse et la localisation
                  AddressCardWidget(
                    key: ValueKey(newHorse.address?.firstOrNull?.idAddress ?? 'default'),
                    addresses: newHorse.address ?? [],
                    userSelectedId: null,
                    onAdresseChanged: (updatedAddresses) {
                      setState(() {
                        newHorse = newHorse.copyWith(
                          address: updatedAddresses.isEmpty ? null : updatedAddresses,
                        );
                      });
                    },
                    openWithCreateHorsePage: true,
                    openWithCreateClientPage: false,
                    openWithManagementHorsePage: false,
                  ),

                  const SizedBox(height: 16),

                  // Widget pour les notes
                    NotesCardWidget(
                      initialNotes: newHorse.notes ?? '',
                      onNotesChanged: (value) => setState(() {
                        horseNotes = value;
                        newHorse = newHorse.copyWith(notes: value);
                      }),
                      openWithCreateHorsePage: true,
                      openWithCreateClientPage: false,
                      openWithManagementHorsePage: false,
                      visitId: null,
                      proID: widget.proID,
                      customId: null,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isValid = await _horseCardKey.currentState!.validateForm();
            if (!isValid) return;

          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await saveHorse();
          }
        },
        child: const Icon(Icons.save, color: Constants.appBarBackgroundColor),
        backgroundColor: Constants.turquoiseDark,
      ),
    );
  }
}

