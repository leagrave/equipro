import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';


class EcurieCardWidget extends StatefulWidget {
  final int idEcurie;
  final String initialName;
  final int ownerId;
  final String adresse;
  final Function(String)? onNameChanged;
  final Function(int)? onOwnerIdChanged;
  final Function(String)? onAdresseChanged;
  final Function()? onSave;

  const EcurieCardWidget({
    Key? key,
    required this.idEcurie,
    required this.initialName,
    required this.ownerId,
    required this.adresse,
    this.onNameChanged,
    this.onOwnerIdChanged,
    this.onAdresseChanged,
    this.onSave,
  }) : super(key: key);

  @override
  _EcurieCardWidgetState createState() => _EcurieCardWidgetState();
}

class _EcurieCardWidgetState extends State<EcurieCardWidget> {
  late TextEditingController _nameController;
  late TextEditingController _ownerController;
  late TextEditingController _adresseController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _ownerController = TextEditingController(text: widget.ownerId.toString());
    _adresseController = TextEditingController(text: widget.adresse);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  // Fonction pour activer/désactiver le mode édition
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // Fonction pour annuler les changements
  void _cancelEdit() {
    setState(() {
      _nameController.text = widget.initialName;
      _ownerController.text = widget.ownerId.toString();
      _adresseController.text = widget.adresse;
      _isEditing = false;
    });
  }

  // Fonction pour sauvegarder les changements
  void _saveChanges() {
    // Appeler les callbacks avec les nouvelles valeurs
    widget.onNameChanged?.call(_nameController.text);
    widget.onOwnerIdChanged?.call(int.tryParse(_ownerController.text) ?? widget.ownerId);
    widget.onAdresseChanged?.call(_adresseController.text);

    // Appeler le callback pour signaler que les changements ont été sauvegardés
    widget.onSave?.call();

    _toggleEdit();
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
              // Champ "Nom de l'écurie"
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nom de l’écurie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _nameController,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 8),

              // Champ "Propriétaire" (actuellement texte, à remplacer par une sélection)
              TextField(
                decoration: InputDecoration(
                  labelText: 'ID Propriétaire',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _ownerController,
                readOnly: !_isEditing,
                keyboardType: TextInputType.number,
              ),
              // NOTE : Remplace ce TextField par un `DropdownButton` ou un autre widget pour sélectionner un client.

              const SizedBox(height: 8),

              // Champ "Adresse"
              TextField(
                decoration: InputDecoration(
                  labelText: 'Adresse de l’écurie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _adresseController,
                readOnly: !_isEditing,
              ),

              const SizedBox(height: 16),

              // Boutons "Modifier", "Annuler", "Sauvegarder"
              if (_isEditing) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _cancelEdit,
                      child: const Text('Annuler',style: TextStyle(color: Constants.appBarBackgroundColor),),
                    ),
                    TextButton(
                      onPressed: _saveChanges,
                      child: const Text('Sauvegarder',style: TextStyle(color: Constants.appBarBackgroundColor),),
                    ),
                  ],
                ),
              ] else ...[
                TextButton(
                  onPressed: _toggleEdit,
                  child: const Text('Modifier',style: TextStyle(color: Constants.appBarBackgroundColor),),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
