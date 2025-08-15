import 'dart:async';
import 'package:equipro/src/models/intervention.dart';
import 'package:equipro/src/models/observation.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/search/selectedMultipleComboCardWidget.dart';
import 'package:equipro/src/widgets/search/selectedDateField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InterventionCardWidget extends StatefulWidget {
  final Intervention intervention;
  final Function(Intervention)? onInterventionUpdated;
  final bool openWithCreateInterventionPage;
  final Function()? onSave;
  final bool isEditing;
  final Function(bool)? onEditingChanged; 
  final Function(bool isSave)? onSaveStateChanged;
  final String proID;


  const InterventionCardWidget({
    Key? key,
    required this.intervention,
    required this.openWithCreateInterventionPage,
    this.onInterventionUpdated,
    this.onSave,
    required this.isEditing,
    this.onEditingChanged,
    this.onSaveStateChanged,
    required this.proID,
  }) : super(key: key);

  @override
  InterventionCardWidgetState createState() => InterventionCardWidgetState();
}

class InterventionCardWidgetState extends State<InterventionCardWidget> {
  late Intervention _intervention;
  late Intervention _originalIntervention;

  bool _loadingDropdowns = true;

    // TextEditingControllers pour les champs non booléens
  late TextEditingController _idController;
  late TextEditingController _horseController;
  late TextEditingController _userController;
  late TextEditingController _descriptionController;
  late TextEditingController _interventionDateController;
  late TextEditingController _invoiceController;
  late TextEditingController _externalNotesController;
  late TextEditingController _incisiveNotesController;
  late TextEditingController _mucousNotesDateController;
  late TextEditingController _internalNotesController;
  late TextEditingController _otherNotesDateController;
  late TextEditingController _externalObservationsController;
  late TextEditingController _incisiveObservationsController;
  late TextEditingController _mucousObservationsController;
  late TextEditingController _internalObservationsController;
  late TextEditingController _otherObservationsController;

  List<Observation> _externalObservationsItems = [];
  List<Observation> _incisiveObservationsItems = [];
  List<Observation> _mucousObservationsItems = [];
  List<Observation> _internalObservationsItems = [];
  List<Observation> _otherObservationsItems = [];

  late List<Observation> _selectedExternalObservation;
  late List<Observation> _selectedincisiveObservations;
  late List<Observation> _selectedmucousObservations;
  late List<Observation> _selectedinternalObservations;
  late List<Observation> _selectedotherObservations;

  bool _showExternalDropdown = false;
  bool _showIncisiveDropdown = false;
  bool _showMucousDropdown = false;
  bool _showInternalDropdown = false;
  bool _showOtherDropdown = false;


@override
void initState() {
  super.initState();

  _intervention = widget.intervention;
  _originalIntervention= widget.intervention.copyWith();



  // Initialisation des contrôleurs avec les valeurs du client
    _idController = TextEditingController(text: _intervention.id);
    _horseController = TextEditingController(text: _intervention.horse?.name ?? '');
    _userController = TextEditingController(
      text: _intervention.users
          .map((u) => "${u.firstName} ${u.lastName}")
          .join(', '),
    );
    _descriptionController = TextEditingController(text: _intervention.description ?? "");
    _interventionDateController = TextEditingController(
      text: _intervention.interventionDate != null
          ? DateFormat('dd/MM/yyyy').format(_intervention.interventionDate!)
          : "",
    );
    _invoiceController = TextEditingController(text: _intervention.invoice?.number ?? '');
    _externalNotesController = TextEditingController(text: _intervention.externalNotes);
    _incisiveNotesController = TextEditingController(text: _intervention.incisiveNotes);
    _mucousNotesDateController = TextEditingController(text: _intervention.mucousNotes);
    _internalNotesController = TextEditingController(text: _intervention.internalNotes);
    _otherNotesDateController = TextEditingController(text: _intervention.otherNotes);

    _externalObservationsController = TextEditingController();
    _incisiveObservationsController = TextEditingController();
    _mucousObservationsController = TextEditingController();
    _internalObservationsController = TextEditingController();
    _otherObservationsController = TextEditingController();

    _selectedExternalObservation = _intervention.externalObservations ?? [];
    _selectedincisiveObservations = _intervention.incisiveObservations ?? [];
    _selectedmucousObservations = _intervention.mucousObservations ?? [];
    _selectedinternalObservations = _intervention.internalObservations ?? [];
    _selectedotherObservations = _intervention.otherObservations ?? [];


  if (widget.openWithCreateInterventionPage == true) {
      widget.onEditingChanged?.call(true);

    }

  _loadDropdownData();
}

  void _toggleExternalCard() {
    setState(() {
      _showExternalDropdown = !_showExternalDropdown;
    });
  }
    void _toggleIncisiveCard() {
    setState(() {
      _showIncisiveDropdown = !_showIncisiveDropdown;
    });
  }

  void _toggleMucousCard() {
    setState(() {
      _showMucousDropdown = !_showMucousDropdown;
    });
  }

  void _toggleInternalCard() {
    setState(() {
      _showInternalDropdown= !_showInternalDropdown;
    });
  }

    void _toggleOtherCard() {
    setState(() {
      _showOtherDropdown= !_showOtherDropdown;
    });
  }

  Future<bool> validateForm() async {
    return await _validateForm();
  }


Future<bool> _validateForm() async {
  final intervantionDate = _intervention.interventionDate != null
          ? DateFormat('dd/MM/yyyy').format(_intervention.interventionDate!)
          : '';

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

  if (!isValidDate(intervantionDate)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("La date de visite est invalide")),
    );
    return false;
  }

  return true;
}


  Future<void> _loadDropdownData() async {
    try {
      final data = await fetchInterventionDropdownData();

      setState(() {
        final observationsData = data['data']; 

        _externalObservationsItems = (observationsData['external_observations'] as List).map((e) {
          return Observation(
            id: e['id'].toString(),
            observationName: e['observation_name'],
          );
        }).toList();

        _incisiveObservationsItems = (observationsData['incisive_observations'] as List).map((e) {
          return Observation(
            id: e['id'].toString(),
            observationName: e['observation_name'],
          );
        }).toList();

        _mucousObservationsItems = (observationsData['mucous_observations'] as List).map((e) {
          return Observation(
            id: e['id'].toString(),
            observationName: e['observation_name'],
          );
        }).toList();

        _internalObservationsItems = (observationsData['internal_observations'] as List).map((e) {
          return Observation(
            id: e['id'].toString(),
            observationName: e['observation_name'],
          );
        }).toList();

        // Vérifie que other_observations n'est pas null avant de mapper
        _otherObservationsItems = observationsData['other_observations'] != null
          ? (observationsData['other_observations'] as List).map((e) {
              return Observation(
                id: e['id'].toString(),
                observationName: e['observation_name'],
              );
            }).toList()
          : [];

        _loadingDropdowns = false;
      });

      print(_internalObservationsItems);

    } catch (e) {
      debugPrint("Erreur lors du chargement des données dropdown: $e");
    }
  }


Future<void> _validerEtMettreAJourIntervention() async {
  if (!await _validateForm()) return;

  final id = _idController.text.trim();
  if (id.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("L'identifiant de l'intervention est vide.")),
    );
    return;
  }

  final response = await ApiService.putWithAuth(
    "/intervention/$id",
    {
      'users': _userController.text.trim(),
      'horse': _horseController.text.trim(),
      'pro_id': widget.proID,
      'description': _descriptionController.text.trim(),
      'intervention_date': DateTime.tryParse(_interventionDateController.text.trim())?.toIso8601String(),
      'invoice': _invoiceController.text.trim(),
      'external_notes': _externalNotesController.text.trim(),
      'incisive_notes': _incisiveNotesController.text.trim(),
      'mucous_notes': _mucousNotesDateController.text.trim(),
      'internal_notes': _internalNotesController.text.trim(),
      'other_notes': _otherNotesDateController.text.trim(),
      'external_observations': _externalObservationsController.text.trim(),
      'incisive_observations': _incisiveObservationsController.text.trim(),
      'mucous_observations': _mucousObservationsController.text.trim(),
      'internal_observations': _internalObservationsController.text.trim(),
      'other_observations': _otherObservationsController.text.trim(),
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    setState(() {
      _intervention = Intervention.fromJson(responseData);
      widget.onEditingChanged?.call(false);
    });

    widget.onInterventionUpdated?.call(_intervention);
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




    Future<Map<String, dynamic>> fetchInterventionDropdownData() async {
      final response = await ApiService.getWithAuth("/infosIntervention");

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors du chargement des données dropdown');
      }
    }


@override
void dispose() {
  _idController.dispose();
  _horseController.dispose();
  _userController.dispose();
  _descriptionController.dispose();
  _interventionDateController.dispose();
  _invoiceController.dispose();
  _externalNotesController.dispose();
  _incisiveNotesController.dispose();
  _mucousNotesDateController.dispose();
  _internalNotesController.dispose();
  _otherNotesDateController.dispose();
  _externalObservationsController.dispose();
  _incisiveObservationsController.dispose();
  _mucousObservationsController.dispose();
  _internalObservationsController.dispose();
  _otherObservationsController.dispose();
  super.dispose();
}


void _handleSaveOrCancel({required bool isSave}) {
  setState(() {
    if (isSave) {
      _validerEtMettreAJourIntervention();
      widget.onSaveStateChanged?.call(true);
    } else {
      // Restaure l'état initial de l'intervention
      _intervention = _originalIntervention;

      // Réinitialise les contrôleurs
      _idController.text = _intervention.id ?? '';
      _horseController.text = _intervention.horse?.name ?? '';
      _userController.text = _intervention.users.map((u) => "${u.firstName} ${u.lastName}").join(', ');
      _descriptionController.text = _intervention.description ?? '';
      _interventionDateController.text = _intervention.interventionDate != null
          ? DateFormat('dd/MM/yyyy').format(_intervention.interventionDate!)
          : '';
      _invoiceController.text = _intervention.invoice?.number ?? '';
      _externalNotesController.text = _intervention.externalNotes ?? '';
      _incisiveNotesController.text = _intervention.incisiveNotes ?? '';
      _mucousNotesDateController.text = _intervention.mucousNotes ?? '';
      _internalNotesController.text = _intervention.internalNotes ?? '';
      _otherNotesDateController.text = _intervention.otherNotes ?? '';

      _selectedExternalObservation = List.from(_intervention.externalObservations ?? []);
      _selectedincisiveObservations = List.from(_intervention.incisiveObservations ?? []);
      _selectedmucousObservations = List.from(_intervention.mucousObservations ?? []);
      _selectedinternalObservations = List.from(_intervention.internalObservations ?? []);
      _selectedotherObservations = List.from(_intervention.otherObservations ?? []);
    }

    widget.onEditingChanged?.call(false);
    widget.onSaveStateChanged?.call(false);
  });
}


void _updateIntervention({
  String? id,
  String? description,
  DateTime? interventionDate,
  String? invoiceNumber,
  String? externalNotes,
  String? incisiveNotes,
  String? mucousNotes,
  String? internalNotes,
  String? otherNotes,
  List<Observation>? externalObservations,
  List<Observation>? incisiveObservations,
  List<Observation>? mucousObservations,
  List<Observation>? internalObservations,
  List<Observation>? otherObservations,
}) {
  setState(() {
    _intervention = _intervention.copyWith(
      id: id ?? _intervention.id,
      description: description ?? _intervention.description,
      interventionDate: interventionDate ?? _intervention.interventionDate,
      invoice: _intervention.invoice?.copyWith(number: invoiceNumber ?? _intervention.invoice?.number),
      externalNotes: externalNotes ?? _intervention.externalNotes,
      incisiveNotes: incisiveNotes ?? _intervention.incisiveNotes,
      mucousNotes: mucousNotes ?? _intervention.mucousNotes,
      internalNotes: internalNotes ?? _intervention.internalNotes,
      otherNotes: otherNotes ?? _intervention.otherNotes,
      externalObservations: externalObservations ?? _intervention.externalObservations,
      incisiveObservations: incisiveObservations ?? _intervention.incisiveObservations,
      mucousObservations: mucousObservations ?? _intervention.mucousObservations,
      internalObservations: internalObservations ?? _intervention.internalObservations,
      otherObservations: otherObservations ?? _intervention.otherObservations,
    );
  });

  widget.onInterventionUpdated?.call(_intervention);
}




void _onExternalSelected() {
    setState(() {
      _showExternalDropdown = false;
    });
}
void _onIncisiveSelected() {
    setState(() {
      _showIncisiveDropdown = false;
    });
}
void _onInternalSelected() {
    setState(() {
      _showInternalDropdown = false;
    });
}
void _onMucousSelected() {
    setState(() {
      _showMucousDropdown = false;
    });
}
void _onOtherSelected() {
    setState(() {
      _showOtherDropdown = false;
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
            'Intervention',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Constants.white, 
            ),
          ),
          const SizedBox(height: 8),

          //if (!widget.openWithCreateInterventionPage)
     
          Row(
            children: [
              SizedBox(
                width: 115, 
                child: SelectedDateField(
                  label: "Date de la visite",
                  selectedDate: _intervention.interventionDate,
                  enabled: widget.isEditing,
                  onDateSelected: (date) {
                    setState(() {
                      _intervention = _intervention.copyWith(interventionDate: date);
                      _interventionDateController.text = date != null ? DateFormat('dd/MM/yyyy').format(date) : '';
                    });
                  },
                ),
              ),
            ],
          ),


     
    
              const SizedBox(height: 8),

              // External Observation
              SelectedMultipleComboCardWidget<Observation>(
                title: "Oberservation externe",
                itemList: _externalObservationsItems,
                selectedItems: _selectedExternalObservation,
                itemLabelBuilder: (externalOb) => externalOb.observationName,
                onItemSelected: (externalOb) {
                  if (externalOb != null && !_selectedExternalObservation.contains(externalOb)) {
                    setState(() => _selectedExternalObservation.add(externalOb));
                  }
                  _onExternalSelected();
                },
                onRemoveItem: (externalOb) {
                  setState(() => _selectedExternalObservation.remove(externalOb));
                },
                onAddPressed: _toggleExternalCard, 
                onDropdownCancel: _toggleExternalCard, 
                showDropdown: _showExternalDropdown,
                searchHintText: "Rechercher une oberservation externe",
                readOnly: !widget.isEditing,
              ),
          const SizedBox(height: 8),

              // External Note
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes observation externe',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                controller: _externalNotesController,
                readOnly: !widget.isEditing,
                onChanged: (value) => _updateIntervention(externalNotes: value),
              ),

               const SizedBox(height: 8),

              // Incisives Observation
              SelectedMultipleComboCardWidget<Observation>(
                title: "Oberservation incisives",
                itemList: _incisiveObservationsItems,
                selectedItems: _selectedincisiveObservations,
                itemLabelBuilder: (incisive) => incisive.observationName,
                onItemSelected: (incisive) {
                  if (incisive != null && !_selectedincisiveObservations.contains(incisive)) {
                    setState(() => _selectedincisiveObservations.add(incisive));
                  }
                  _onIncisiveSelected();
                },
                onRemoveItem: (incisive) {
                  setState(() => _selectedincisiveObservations.remove(incisive));
                },
                onAddPressed: _toggleIncisiveCard, 
                onDropdownCancel: _toggleIncisiveCard, 
                showDropdown: _showIncisiveDropdown,
                searchHintText: "Rechercher une oberservation des incisives",
                readOnly: !widget.isEditing,
              ),

          const SizedBox(height: 8),
              // Incisives Note
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes observation incisives',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                controller: _incisiveNotesController,
                readOnly: !widget.isEditing,
                onChanged: (value) => _updateIntervention(incisiveNotes: value),
              ),
              const SizedBox(height: 8),

              // Mucous Observation
              SelectedMultipleComboCardWidget<Observation>(
                title: "Oberservation des muqueuses",
                itemList: _mucousObservationsItems,
                selectedItems: _selectedmucousObservations,
                itemLabelBuilder: (mucous) => mucous.observationName,
                onItemSelected: (mucous) {
                  if (mucous != null && !_selectedmucousObservations.contains(mucous)) {
                    setState(() => _selectedmucousObservations.add(mucous));
                  }
                  _onMucousSelected();
                },
                onRemoveItem: (mucous) {
                  setState(() => _selectedmucousObservations.remove(mucous));
                },
                onAddPressed: _toggleMucousCard, 
                onDropdownCancel: _toggleMucousCard, 
                showDropdown: _showMucousDropdown,
                searchHintText: "Rechercher une oberservation des muqueuses",
                readOnly: !widget.isEditing,
              ),
          const SizedBox(height: 8),

              // Mucous Note
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes observation des muqueuses',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                controller: _mucousNotesDateController,
                readOnly: !widget.isEditing,
                onChanged: (value) => _updateIntervention(mucousNotes: value),
              ),

              const SizedBox(height: 8),

              // Internal Observation
              SelectedMultipleComboCardWidget<Observation>(
                title: "Oberservation interne",
                itemList: _internalObservationsItems,
                selectedItems: _selectedinternalObservations,
                itemLabelBuilder: (internal) => internal.observationName,
                onItemSelected: (internal) {
                  if (internal != null && !_selectedinternalObservations.contains(internal)) {
                    setState(() => _selectedinternalObservations.add(internal));
                  }
                  _onInternalSelected();
                },
                onRemoveItem: (internal) {
                  setState(() => _selectedinternalObservations.remove(internal));
                },
                onAddPressed: _toggleInternalCard, 
                onDropdownCancel: _toggleInternalCard, 
                showDropdown: _showInternalDropdown,
                searchHintText: "Rechercher une oberservation interne",
                readOnly: !widget.isEditing,
              ),
          const SizedBox(height: 8),

              // Internal Note
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes observation interne',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                controller: _internalNotesController,
                readOnly: !widget.isEditing,
                onChanged: (value) => _updateIntervention(internalNotes: value),
              ),

              const SizedBox(height: 8),

              // Other Observation
              SelectedMultipleComboCardWidget<Observation>(
                title: "Oberservation autre",
                itemList: _otherObservationsItems,
                selectedItems: _selectedotherObservations,
                itemLabelBuilder: (other) => other.observationName,
                onItemSelected: (other) {
                  if (other != null && !_selectedotherObservations.contains(other)) {
                    setState(() => _selectedotherObservations.add(other));
                  }
                  _onOtherSelected();
                },
                onRemoveItem: (other) {
                  setState(() => _selectedotherObservations.remove(other));
                },
                onAddPressed: _toggleOtherCard, 
                onDropdownCancel: _toggleOtherCard, 
                showDropdown: _showOtherDropdown,
                searchHintText: "Rechercher une oberservation autre",
                readOnly: !widget.isEditing,
              ),
          const SizedBox(height: 8),

              // Other Note
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),

                controller: _otherNotesDateController,
                readOnly: !widget.isEditing,
                onChanged: (value) => _updateIntervention(otherNotes: value),
              ),
              const SizedBox(height: 8),

              // Afficher les boutons si onHorseUpdated est null
              if (!widget.openWithCreateInterventionPage)
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

