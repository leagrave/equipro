import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';

class ClientNotesCardWidget extends StatelessWidget {
  final String initialNotes;
  final Function(String)? onNotesChanged;

  const ClientNotesCardWidget({
    Key? key,
    required this.initialNotes,
    this.onNotesChanged,
  }) : super(key: key);

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
              // Champ de texte multi-lignes pour les notes
              TextField(
                decoration: InputDecoration(
                  labelText: 'Commentaires',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: TextEditingController(text: initialNotes),
                onChanged: onNotesChanged,
                maxLines: 5, // Permet d'avoir plusieurs lignes de texte
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLength: 500, // Limite le nombre de caractères si nécessaire
              ),
            ],
          ),
        ),
      ),
    );
  }
}
