import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';

class ClientNotesCardWidget extends StatefulWidget {
  final String initialNotes;
  final Function(String)? onNotesChanged;

  const ClientNotesCardWidget({
    Key? key,
    required this.initialNotes,
    this.onNotesChanged,
  }) : super(key: key);

  @override
  _ClientNotesCardWidgetState createState() => _ClientNotesCardWidgetState();
}

class _ClientNotesCardWidgetState extends State<ClientNotesCardWidget> {
  bool _isEditing = false;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.8), // Fond transparent
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ de texte multi-lignes pour les commentaires
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Commentaires',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: widget.onNotesChanged,
                maxLines: 5, // Permet d'avoir plusieurs lignes de texte
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLength: 500, // Limite le nombre de caractères si nécessaire
                readOnly: !_isEditing, // Mode lecture seule si pas en mode édition
              ),
              const SizedBox(height: 16),
              // Bouton pour activer/désactiver l'édition
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_isEditing) {
                          // Si on sauvegarde les modifications, on appelle le callback
                          if (widget.onNotesChanged != null) {
                            widget.onNotesChanged!(_notesController.text);
                          }
                        }
                        _isEditing = !_isEditing;
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
