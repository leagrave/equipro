import 'package:flutter/material.dart';
import 'package:equipro/src/models/event.dart';


class EventCardWidget extends StatefulWidget {
  final Event event;
  final Function(Event)? onEventUpdated;
  final bool openWithCreateEventPage;

  const EventCardWidget({
    Key? key,
    required this.event,
    required this.openWithCreateEventPage,
    this.onEventUpdated,
  }) : super(key: key);

  @override
  _EventCardWidgetState createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  late Event _event;
  late Event _originalEvent;
  bool _isEditing = false;

  // TextEditingControllers pour les champs non booléens
  late TextEditingController _eventNameController;
  late TextEditingController _clientNameController;
  late TextEditingController _horseNameController;
  late TextEditingController _stableNameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _originalEvent = widget.event;

    // Initialisation des contrôleurs avec les valeurs de l'événement
    _eventNameController = TextEditingController(text: _event.eventName);
    _clientNameController = TextEditingController(text: _event.idClient.toString());
    _horseNameController = TextEditingController(text: _event.idHorse?.toString() ?? '');
    _stableNameController = TextEditingController(text: _event.idEcurie?.toString() ?? '');
    _addressController = TextEditingController(text: _event.adresseEcurie);

    if (widget.openWithCreateEventPage) {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _clientNameController.dispose();
    _horseNameController.dispose();
    _stableNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSaveOrCancel({required bool isSave}) {
    setState(() {
      if (isSave) {
        // Appelle onSave et onEventUpdated si nécessaire
        widget.onEventUpdated?.call(_event);
      } else {
        // Restaure l'état initial de l'événement
        _event = _originalEvent;
        _eventNameController.text = _event.eventName;
        _clientNameController.text = _event.idClient.toString();
        _horseNameController.text = _event.idHorse?.toString() ?? '';
        _stableNameController.text = _event.idEcurie?.toString() ?? '';
        _addressController.text = _event.adresseEcurie;
      }
      _isEditing = false;
    });
  }

  void _updateEvent({
    String? eventName,
    int? idEvent,
    int? idClient,
    int? idHorse,
    int? idEcurie,
    String? adresseEcurie,
    DateTime? dateDebut,
    DateTime? dateFin,
    DateTime? heureDebut,
    DateTime? heureFin,
  }) {
    setState(() {
      _event = Event(
        idEvent: idEvent ?? _event.idEvent,
        idClient: idClient ?? _event.idClient,
        eventName: eventName ?? _event.eventName,
        idHorse: idHorse ?? _event.idHorse,
        idEcurie: idEcurie ?? _event.idEcurie,
        adresseEcurie: adresseEcurie ?? _event.adresseEcurie,
        dateDebut: dateDebut ?? _event.dateDebut,
        dateFin: dateFin ?? _event.dateFin,
        heureDebut: heureDebut ?? _event.heureDebut,
        heureFin: heureFin ?? _event.heureFin,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nom de l'événement
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'événement',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateEvent(eventName: value),
              ),
              const SizedBox(height: 8),

              // Client
              TextField(
                controller: _clientNameController,
                decoration: InputDecoration(
                  labelText: 'Client',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateEvent(idClient: int.tryParse(value)),
              ),
              const SizedBox(height: 8),

              // Cheval
              TextField(
                controller: _horseNameController,
                decoration: InputDecoration(
                  labelText: 'Cheval',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateEvent(idHorse: int.tryParse(value)),
              ),
              const SizedBox(height: 8),

              // Écurie
              TextField(
                controller: _stableNameController,
                decoration: InputDecoration(
                  labelText: 'Écurie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateEvent(idEcurie: int.tryParse(value)),
              ),
              const SizedBox(height: 8),

              // Adresse de l'écurie
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adresse de l\'écurie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateEvent(adresseEcurie: value),
              ),
              const SizedBox(height: 8),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () => _handleSaveOrCancel(isSave: true),
                      child: const Text('Enregistrer'),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(_isEditing ? 'Annuler' : 'Modifier'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
