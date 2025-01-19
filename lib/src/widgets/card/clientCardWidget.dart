import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';

class ClientCardWidget extends StatefulWidget {
  final int idClient;
  final String initialName;
  final String initialSurname;
  final String tel;
  final String email;
  final bool isSociete; 
  final Function(String)? onNameChanged;
  final Function(String)? onSurnameChanged;
  final Function(String)? onTelChanged;
  final Function(String)? onEmailChanged;
  final Function(bool)? onIsSocieteChanged; 

  const ClientCardWidget({
    Key? key,
    required this.idClient,
    required this.initialName,
    required this.initialSurname,
    required this.tel,
    required this.email,
    required this.isSociete, 
    this.onNameChanged,
    this.onSurnameChanged,
    this.onTelChanged,
    this.onEmailChanged,
    this.onIsSocieteChanged,
  }) : super(key: key);

  @override
  _ClientCardWidgetState createState() => _ClientCardWidgetState();
}

class _ClientCardWidgetState extends State<ClientCardWidget> {
  late bool _isSociete;
  bool _isEditing = false; 

  @override
  void initState() {
    super.initState();
    _isSociete = widget.isSociete;
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
      _isEditing = false;
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
              // Nom modifiable
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: TextEditingController(text: widget.initialName),
                onChanged: widget.onNameChanged,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 8),

              // Prénom modifiable
              TextField(
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: TextEditingController(text: widget.initialSurname),
                onChanged: widget.onSurnameChanged,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 8),

              // Téléphone modifiable
              TextField(
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: TextEditingController(text: widget.tel),
                onChanged: widget.onTelChanged,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 8),

              // Email modifiable
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: TextEditingController(text: widget.email),
                onChanged: widget.onEmailChanged,
                readOnly: !_isEditing,
              ),

              // Checkbox pour déterminer si le client est une société
              Row(
                children: [
                  Checkbox(
                    value: _isSociete,
                    onChanged: _isEditing ? (bool? newValue) {
                      setState(() {
                        _isSociete = newValue ?? false;
                      });
                      // Si un callback est passé, l'appelle pour signaler le changement
                      if (widget.onIsSocieteChanged != null) {
                        widget.onIsSocieteChanged!(_isSociete);
                      }
                    } : null, 
                  ),
                  Text('Société'),
                ],
              ),

              // Affichage des boutons "Modifier", "Annuler", "Sauvegarder"
              if (_isEditing) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _cancelEdit, 
                      child: Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () {
                        _toggleEdit(); 
                        widget.onNameChanged?.call(widget.initialName);
                        widget.onSurnameChanged?.call(widget.initialSurname);
                        widget.onTelChanged?.call(widget.tel);
                        widget.onEmailChanged?.call(widget.email);
                      },
                      child: Text('Sauvegarder'),
                    ),
                  ],
                ),
              ] else ...[
                TextButton(
                  onPressed: _toggleEdit, 
                  child: Text('Modifier'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
