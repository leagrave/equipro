import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';

class ClientCardWidget extends StatefulWidget {
  final Client client;
  final Function(Client)? onClientUpdated;
  final bool openWithCreateClientPage;

  const ClientCardWidget({
    Key? key,
    required this.client,
    required this.openWithCreateClientPage,
    this.onClientUpdated,
  }) : super(key: key);

  @override
  _ClientCardWidgetState createState() => _ClientCardWidgetState();
}

class _ClientCardWidgetState extends State<ClientCardWidget> {
  late Client _client;
  bool _isEditing = false;

  // TextEditingControllers pour les champs qui ne sont pas booléens
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

    // Initialisation des contrôleurs avec les valeurs du client
    _nomController = TextEditingController(text: _client.nom);
    _prenomController = TextEditingController(text: _client.prenom);
    _telController = TextEditingController(text: _client.tel);
    _emailController = TextEditingController(text: _client.email);
    _villeController = TextEditingController(text: _client.ville);

    // Initialiser la variable temporaire avec la valeur de isSociete
    _tempIsSociete = _client.isSociete;

    if (widget.openWithCreateClientPage == true) {
      setState(() {
        _isEditing = !_isEditing;
      });
    }
  }

  @override
  void dispose() {
    // Libération des ressources des contrôleurs
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  void _updateClient({
    String? nom,
    String? prenom,
    String? tel,
    String? tel2,
    String? email,
    String? ville,
    String? societe,
    String? civilite,
    DateTime? derniereVisite,
    DateTime? prochaineIntervention,
    String? adresse,
    String? adresseFacturation,
    String? region,
    String? notes,
    List<String>? adresses,
    bool? isSociete, 
  }) {
    setState(() {
      _client = Client(
        idClient: _client.idClient,
        nom: nom ?? _client.nom,
        prenom: prenom ?? _client.prenom,
        tel: tel ?? _client.tel,
        tel2: tel2 ?? _client.tel2,
        email: email ?? _client.email,
        ville: ville ?? _client.ville,
        societe: societe ?? _client.societe, 
        civilite: civilite ?? _client.civilite,
        isSociete: _tempIsSociete ?? _client.isSociete,  
        derniereVisite: derniereVisite ?? _client.derniereVisite,
        prochaineIntervention: prochaineIntervention ?? _client.prochaineIntervention,
        adresse: adresse ?? _client.adresse,
        adresseFacturation: adresseFacturation ?? _client.adresseFacturation,
        region: region ?? _client.region,
        notes: notes ?? _client.notes,
        adresses: adresses ?? _client.adresses
      );
    });

    if (widget.onClientUpdated != null) {
      widget.onClientUpdated!(_client);
    }
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

              // Afficher les boutons
              if (!widget.openWithCreateClientPage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isEditing) ...[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Réinitialise l'état de _client et les contrôleurs
                            _client = widget.client;
                            _nomController.text = _client.nom ?? '';
                            _prenomController.text = _client.prenom ?? '';
                            _telController.text = _client.tel ?? '';
                            _emailController.text = _client.email ?? '';
                            _villeController.text = _client.ville ?? '';
                            _tempIsSociete = _client.isSociete;  // Réinitialiser la variable temporaire
                            _isEditing = false;
                          });
                        },
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                          if (_isEditing) {
                            _updateClient(nom: _client.nom);
                          }
                        });
                      },
                      child: Text(_isEditing ? 'Enregistrer' : 'Modifier'),
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
