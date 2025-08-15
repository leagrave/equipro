import 'dart:async';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/search/selectedMultipleComboCardWidget.dart';
import 'package:equipro/src/widgets/search/selectedDateField.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/horseBreed.dart';
import 'package:equipro/src/models/horseColor.dart';
import 'package:equipro/src/models/horseFeedType.dart';
import 'package:equipro/src/models/horseActivityType.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HorseCardWidget extends StatefulWidget {
  final Horse horse;
  final Function(Horse)? onHorseUpdated;
  final bool openWithCreateHorsePage;
  final Function()? onSave;
  final bool isEditing;
  final Function(bool)? onEditingChanged; 
  final Function(bool isSave)? onSaveStateChanged;


  const HorseCardWidget({
    Key? key,
    required this.horse,
    required this.openWithCreateHorsePage,
    this.onHorseUpdated,
    this.onSave,
    required this.isEditing,
    this.onEditingChanged,
    this.onSaveStateChanged,
  }) : super(key: key);

  @override
  HorseCardWidgetState createState() => HorseCardWidgetState();
}

class HorseCardWidgetState extends State<HorseCardWidget> {
  late Horse _horse;
  late Horse _originalHorse;

  

  // TextEditingControllers pour les champs non booléens
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  late TextEditingController _feedController;
  late TextEditingController _activityController;
  late TextEditingController _lastVisitDateController;
  late TextEditingController _nextVisitDateController;

  List<HorseBreed> _breedItems = [];
  List<HorseColor> _colorItems = [];
  List<FeedType> _feedItems = [];
  List<ActivityType> _activityItems = [];

  bool _loadingDropdowns = true;
  late List<HorseBreed> _selectedBreeds;
  late List<HorseColor> _selectedColors;
  late List<FeedType> _selectedFeedTypes;
  late List<ActivityType> _selectedActivityTypes;


  bool _showBreedDropdown = false;
  bool _showColorDropdown = false;
  bool _showFeedTypeDropdown = false;
  bool _showActivityTypeDropdown = false;


@override
void initState() {
  super.initState();

  _horse = widget.horse;
  _originalHorse = widget.horse.copyWith();

  _idController = TextEditingController(text: _horse.id);
  _nameController = TextEditingController(text: _horse.name);
  _ageController = TextEditingController(text: _horse.age == 0 ? '' : _horse.age.toString(),);
  _breedController = TextEditingController();
  _colorController = TextEditingController();
  _feedController = TextEditingController();
  _activityController = TextEditingController();
  _lastVisitDateController = TextEditingController(
      text: _horse.lastVisitDate != null ? DateFormat('dd/MM/yyyy').format(_horse.lastVisitDate!) : "");
  _nextVisitDateController = TextEditingController(
      text: _horse.nextVisitDate != null ? DateFormat('dd/MM/yyyy').format(_horse.nextVisitDate!) : "");

  _selectedBreeds = _horse.breeds ?? [];
  _selectedColors = _horse.colors ?? [];
  _selectedFeedTypes = _horse.feedTypes ?? [];
  _selectedActivityTypes = _horse.activityTypes ?? [];



  if (widget.openWithCreateHorsePage == true) {
      widget.onEditingChanged?.call(true);

    }

  _loadDropdownData();
}

  void _toggleBreedCard() {
    setState(() {
      _showBreedDropdown = !_showBreedDropdown;
    });
  }
    void _toggleColorCard() {
    setState(() {
      _showColorDropdown = !_showColorDropdown;
    });
  }

  void _toggleFeedTypeCard() {
    setState(() {
      _showFeedTypeDropdown = !_showFeedTypeDropdown;
    });
  }

  void _toggleActivityTypeCard() {
    setState(() {
      _showActivityTypeDropdown= !_showActivityTypeDropdown;
    });
  }

  Future<bool> validateForm() async {
    return await _validateForm();
  }


Future<bool> _validateForm() async {
  final name = _nameController.text.trim();
  final lastVisitDateStr = _lastVisitDateController.text.trim();
  final nextVisitDateStr = _nextVisitDateController.text.trim();

  // gérer que la next visite ne doit pas etre avant la date last 

  if (name.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Le nom du cheval doit être rempli")),
    );
    return false;
  }

  // Fonction interne pour valider une date (format ISO 8601 ici)
  bool isValidDate(String dateStr) {
    if (dateStr.isEmpty) return true;
    try {
      DateFormat('dd/MM/yyyy').parseStrict(dateStr); 
      return true;
    } catch (e) {
      return false;
    }
  }

  if (!isValidDate(lastVisitDateStr)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("La date de dernière visite est invalide")),
    );
    return false;
  }

  if (!isValidDate(nextVisitDateStr)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("La date de prochaine visite est invalide")),
    );
    return false;
  }

  return true;
}


  Future<void> _loadDropdownData() async {
    try {
      final data = await fetchHorseDropdownData();

      setState(() {
        _breedItems = (data['breeds'] as List).map((e) {
          final breed = HorseBreed(id: e['id'].toString(), label: e['name']);
          return HorseBreed(id: e['id'].toString(), label: e['name']);
        }).toList();

        _colorItems = (data['colors'] as List).map((e) {
          final color = HorseColor(id: e['id'].toString(), label: e['name']);
          return HorseColor(id: e['id'].toString(), label: e['name']);
        }).toList();

        _feedItems = (data['feedTypes'] as List).map((e) {
          final feed = FeedType(id: e['id'].toString(), label: e['name']);
          return FeedType(id: e['id'].toString(), label: e['name']);
        }).toList();

        _activityItems = (data['activityTypes'] as List).map((e) {
          final activity = ActivityType(id: e['id'].toString(), label: e['name']);
          return ActivityType(id: e['id'].toString(), label: e['name']);
        }).toList();

        _loadingDropdowns = false;
      });
    } catch (e) {
      debugPrint("Erreur lors du chargement des données dropdown: $e");
    }
  }


Future<void> _validerEtMettreAJourCheval() async {
  //if (!await _validateForm()) return;

  final id = _idController.text.trim();
  if (id.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("L'identifiant du cheval est vide.")),
    );
    return;
  }

  final response = await ApiService.putWithAuth(
    "/horse/$id",
    {
      'name': _nameController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'breed_ids': _selectedBreeds.map((e) => e.id).toList(),
      'color_ids': _selectedColors.map((e) => e.id).toList(),
      'feed_type_ids': _selectedFeedTypes.map((e) => e.id).toList(),
      'activity_type_ids': _selectedActivityTypes.map((e) => e.id).toList(),
      'last_visit_date': _lastVisitDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parseStrict(_lastVisitDateController.text).toIso8601String()
          : null,
      'next_visit_date': _nextVisitDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parseStrict(_nextVisitDateController.text).toIso8601String()
          : null,
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    setState(() {
      _horse = Horse.fromJson(responseData);
      widget.onEditingChanged?.call(false);
    });

    widget.onHorseUpdated?.call(_horse);
    widget.onSave?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil mis à jour avec succès.")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors de la mise à jour : ${response.body}")),
    );
  }
}





    Future<Map<String, dynamic>> fetchHorseDropdownData() async {
      final response = await ApiService.getWithAuth("/infosHorse");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors du chargement des données dropdown');
      }
    }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _feedController.dispose();
    _activityController.dispose();
    _lastVisitDateController.dispose();
    _nextVisitDateController.dispose();
    super.dispose();
  }

void _handleSaveOrCancel({required bool isSave}) async {

    if (isSave) {
      final isValid = await _validateForm();
      if (!isValid) return;
      // Appelle la méthode de validation et mise à jour
      await _validerEtMettreAJourCheval();
      //widget.onSaveStateChanged?.call(true);
    } else {
      setState(() {
      // Restaure l'état initial du cheval (_originalHorse)
      _horse = _originalHorse;

      // Remet à jour les contrôleurs avec les valeurs initiales
      _nameController.text = _horse.name;
      _ageController.text = _horse.age.toString();

      // Remets à jour les listes sélectionnées si elles existent
      _selectedBreeds = List.from(_horse.breeds ?? []);
      _selectedColors = List.from(_horse.colors ?? []);
      _selectedFeedTypes = List.from(_horse.feedTypes ?? []);
      _selectedActivityTypes = List.from(_horse.activityTypes ?? []);

      _lastVisitDateController.text = _horse.lastVisitDate != null
          ? DateFormat('dd/MM/yyyy').format(_horse.lastVisitDate!)
          : '';

      _nextVisitDateController.text = _horse.nextVisitDate != null
          ? DateFormat('dd/MM/yyyy').format(_horse.nextVisitDate!)
          : '';

    });

  }
  // Quitte le mode édition dans tous les cas
  widget.onEditingChanged?.call(false);
  widget.onSaveStateChanged?.call(false);
}


  void _updateHorse({
    String? id,
    String? name,
    int? age,
    List<HorseBreed>? breeds,
    List<HorseColor>? colors,
    List<FeedType>? feedTypes,
    List<ActivityType>? activityTypes,
    DateTime? lastVisitDate,
    DateTime? nextVisitDate,
  }) {
    setState(() {
      _horse = _horse.copyWith(
      id: id ?? _horse.id,
      name: name ?? _horse.name,
      age: age ?? _horse.age,
      breeds: breeds ?? _horse.breeds,
      feedTypes: feedTypes ?? _horse.feedTypes,
      colors: colors ?? _horse.colors,
      activityTypes: activityTypes ?? _horse.activityTypes,
      lastVisitDate: lastVisitDate ?? _horse.lastVisitDate,
      nextVisitDate: nextVisitDate ?? _horse.nextVisitDate,
      );
    });
    widget.onHorseUpdated?.call(_horse);
    widget.onSave?.call();
  }


void _onBreedSelected() {
    setState(() {
      _showBreedDropdown = false;
    });
}
void _onColorSelected() {
    setState(() {
      _showColorDropdown = false;
    });
}
void _onFeedTypeSelected() {
    setState(() {
      _showFeedTypeDropdown = false;
    });
}
void _onActivityTypeSelected() {
    setState(() {
      _showActivityTypeDropdown = false;
    });
}




  String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('dd/MM/yyyy').format(date);
  }

    Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType inputType = TextInputType.text, ValueChanged<String>? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: !widget.isEditing,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cheval',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Constants.white, 
            ),
          ),
          const SizedBox(height: 8),

          if (!widget.openWithCreateHorsePage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectedDateField(
                    label: "Dernière visite",
                    selectedDate: _horse.lastVisitDate,
                    enabled: widget.isEditing,
                    onDateSelected: (date) {
                      setState(() {
                        _horse = _horse.copyWith(lastVisitDate: date);
                        _lastVisitDateController.text = date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
                      });
                    },
                  ),

                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectedDateField(
                    label: "Prochaine visite",
                    selectedDate: _horse.nextVisitDate,
                    enabled: widget.isEditing,
                    onDateSelected: (date) {
                      setState(() {
                        _horse = _horse.copyWith(nextVisitDate: date);
                        _nextVisitDateController.text = date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
                      });
                    },
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Prochaine visite',
                  //     filled: true,
                  //     fillColor: Colors.white.withOpacity(0.2),
                  //     labelStyle: const TextStyle(color: Colors.white70),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   controller: TextEditingController(
                  //     text: formatDate(_horse.nextVisitDate),
                  //   ),
                  //   readOnly: widget.isEditing,
                  //   style: const TextStyle(color: Colors.white),
                  // ),
                ),
              ],
            ),
              const SizedBox(height: 8),

              // Nom
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                controller: _nameController,
                readOnly: !widget.isEditing,
                onChanged: (value) => _updateHorse(name: value),
              ),
              const SizedBox(height: 8),

              // Âge
              TextField(
                decoration: InputDecoration(
                  labelText: 'Âge',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                keyboardType: TextInputType.number,
                controller: _ageController,
                readOnly: !widget.isEditing,
                onChanged: (value) {
                  final int? newAge = int.tryParse(value);
                  if (newAge != null) {
                    _updateHorse(age: newAge);
                  }
                },
              ),
              const SizedBox(height: 8),

              // RACE
              SelectedMultipleComboCardWidget<HorseBreed>(
                title: "Races",
                itemList: _breedItems,
                selectedItems: _selectedBreeds,
                itemLabelBuilder: (breed) => breed.label,
                onItemSelected: (breed) {
                  if (breed != null && !_selectedBreeds.contains(breed)) {
                    setState(() => _selectedBreeds.add(breed));
                  }
                  _onBreedSelected();
                },
                onRemoveItem: (breed) {
                  setState(() => _selectedBreeds.remove(breed));
                },
                onAddPressed: _toggleBreedCard, 
                onDropdownCancel: _toggleBreedCard, 
                showDropdown: _showBreedDropdown,
                searchHintText: "Rechercher une race",
                readOnly: !widget.isEditing,
              ),


              const SizedBox(height: 8),

              // COULEUR
              SelectedMultipleComboCardWidget<HorseColor>(
                title: "Couleur",
                itemList: _colorItems,
                selectedItems: _selectedColors,
                itemLabelBuilder: (color) => color.label,
                onItemSelected: (color) {
                  if (color != null && !_selectedColors.contains(color)) {
                    setState(() {
                      _selectedColors.add(color);
                    });
                  }
                  _onColorSelected();
                },
                onAddPressed: _toggleColorCard,
                showDropdown: _showColorDropdown,
                onDropdownCancel: () => setState(() => _showColorDropdown = false),
                onRemoveItem: (color) {
                  setState(() {
                    _selectedColors.remove(color);
                  });
                },
                searchHintText: "Rechercher une couleur...",
                readOnly: !widget.isEditing,
              ),

              const SizedBox(height: 8),

              // ALIMENTATION
              SelectedMultipleComboCardWidget<FeedType>(
                title: "Type d'alimentation",
                itemList: _feedItems,
                selectedItems: _selectedFeedTypes,
                itemLabelBuilder: (feedType) => feedType.label,
                onItemSelected: (feedType) {
                  if (feedType != null && !_selectedFeedTypes.contains(feedType)) {
                    setState(() {
                      _selectedFeedTypes.add(feedType);
                    });
                  }
                  _onFeedTypeSelected();
                },
                onAddPressed: _toggleFeedTypeCard,
                showDropdown: _showFeedTypeDropdown,
                onDropdownCancel: () => setState(() => _showFeedTypeDropdown = false),
                onRemoveItem: (feedType) {
                  setState(() {
                    _selectedFeedTypes.remove(feedType);
                  });
                },
                searchHintText: "Rechercher une alimentation...",
                readOnly: !widget.isEditing,
              ),

              const SizedBox(height: 8),

              // ACTIVITÉ
              SelectedMultipleComboCardWidget<ActivityType>(
                title: "Type d'activité",
                itemList: _activityItems,
                selectedItems: _selectedActivityTypes,
                itemLabelBuilder: (activityType) => activityType.label,
                onItemSelected: (activityType) {
                  if (activityType != null && !_selectedActivityTypes.contains(activityType)) {
                    setState(() {
                      _selectedActivityTypes.add(activityType);
                    });
                  }
                  _onActivityTypeSelected();
                },
                onAddPressed: _toggleActivityTypeCard,
                showDropdown: _showActivityTypeDropdown,
                onDropdownCancel: () => setState(() => _showActivityTypeDropdown = false),
                onRemoveItem: (activityType) {
                  setState(() {
                    _selectedActivityTypes.remove(activityType.id);
                    _horse.activityTypes?.removeWhere((a) => a.id == activityType.id);
                  });
                },
                searchHintText: "Rechercher une activité...",
                readOnly: !widget.isEditing,
              ),

              const SizedBox(height: 8),



              // Afficher les boutons si onHorseUpdated est null
              if (!widget.openWithCreateHorsePage)
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.isEditing)
                    ElevatedButton(
                      onPressed: () => _handleSaveOrCancel(isSave: false),
                      child: const Text('Annuler', style: TextStyle(color: Constants.appBarBackgroundColor),),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.isEditing) {
                        _handleSaveOrCancel(isSave: true);
                      } else {
                        setState(() {
                          //widget.isEditing = true;
                          widget.onEditingChanged?.call(true);

                        });
                      }
                    },
                    child: Text(widget.isEditing ? 'Enregistrer' : 'Modifier',style: TextStyle(color: Constants.appBarBackgroundColor),),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
  }
}
