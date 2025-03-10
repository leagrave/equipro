import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';

class ClientCardWidget extends StatefulWidget {
  final Client client;
  final Function(Client)? onClientUpdated;
  final bool openWithCreateClientPage;
  final bool openWithCreateHorsePage;
  final Function()? onSave;

  const ClientCardWidget({
    Key? key,
    required this.client,
    required this.openWithCreateClientPage,
    required this.openWithCreateHorsePage,
    this.onClientUpdated,
    this.onSave,
  }) : super(key: key);

  @override
  _ClientCardWidgetState createState() => _ClientCardWidgetState();
}

class _ClientCardWidgetState extends State<ClientCardWidget> {
  late Client _client;
  late Client _originalClient; // Garde une copie de l'état initial
  bool _isEditing = false;

  // TextEditingControllers pour les champs non booléens
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telController;
  late TextEditingController _emailController;
  late TextEditingController _villeController;

  // Variable temporaire pour isSociete
  bool? _tempIsSociete;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
    _originalClient = widget.client;

    // Initialisation des contrôleurs avec les valeurs du client
    _nomController = TextEditingController(text: _client.nom);
    _prenomController = TextEditingController(text: _client.prenom);
    _telController = TextEditingController(text: _client.tel);
    _emailController = TextEditingController(text: _client.email);
    _villeController = TextEditingController(text: _client.ville);

    // Initialiser la variable temporaire avec la valeur de isSociete
    _tempIsSociete = _client.isSociete;

    if (widget.openWithCreateClientPage || widget.openWithCreateHorsePage) {
      _isEditing = true;
    }

  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  void _handleSaveOrCancel({required bool isSave}) {
    setState(() {
      if (isSave) {
        // Appelle onSave et onClientUpdated si nécessaire
        widget.onSave?.call();
        if (widget.onClientUpdated != null) {
          widget.onClientUpdated!(_client);
        }
      } else {
        // Restaure l'état initial du client
        _client = _originalClient;
        _nomController.text = _client.nom;
        _prenomController.text = _client.prenom;
        _telController.text = _client.tel;
        _emailController.text = _client.email ?? "";
        _villeController.text = _client.ville ?? "";
        _tempIsSociete = _client.isSociete;
      }
      _isEditing = false;
    });
  }

  void _updateClient({
    String? nom,
    String? prenom,
    String? tel,
    String? email,
    String? ville,
    bool? isSociete,
  }) {
    setState(() {
      _client = Client(
        idClient: _client.idClient,
        nom: nom ?? _client.nom,
        prenom: prenom ?? _client.prenom,
        tel: tel ?? _client.tel,
        email: email ?? _client.email,
        ville: ville ?? _client.ville,
        isSociete: isSociete ?? _tempIsSociete ?? false,
        societe: _client.societe,
        civilite: _client.civilite,
        derniereVisite: _client.derniereVisite,
        prochaineIntervention: _client.prochaineIntervention,
        adresse: _client.adresse,
        adresseFacturation: _client.adresseFacturation,
        region: _client.region,
        notes: _client.notes,
        adresses: _client.adresses,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nom
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateClient(nom: value),
              ),
              const SizedBox(height: 8),

              // Prénom
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateClient(prenom: value),
              ),
              const SizedBox(height: 8),

              // Téléphone
              TextField(
                controller: _telController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateClient(tel: value),
              ),
              const SizedBox(height: 8),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateClient(email: value),
              ),
              const SizedBox(height: 8),

              // Ville
              TextField(
                controller: _villeController,
                decoration: InputDecoration(
                  labelText: 'Ville',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                readOnly: !_isEditing,
                onChanged: (value) => _updateClient(ville: value),
              ),
              const SizedBox(height: 8),

              // Societe (Checkbox)
              Row(
                children: [
                  Checkbox(
                    value: _tempIsSociete,
                    onChanged: _isEditing
                        ? (bool? value) {
                            setState(() {
                              _tempIsSociete = value ?? false;
                            });
                          }
                        : null,
                  ),
                  const Text('Société'),
                ],
              ),
              const SizedBox(height: 8),

              if(!widget.openWithCreateClientPage)
              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () => _handleSaveOrCancel(isSave: true),
                      child: const Text('Annuler', style: TextStyle(color: Constants.appBarBackgroundColor),),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_isEditing) {
                        _handleSaveOrCancel(isSave: true);
                      } else {
                        setState(() {
                          _isEditing = true;
                        });
                      }
                    },
                    child: Text(_isEditing ? 'Enregistrer' : 'Modifier',style: TextStyle(color: Constants.appBarBackgroundColor),),
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
