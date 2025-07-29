import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotesCardWidget extends StatefulWidget {
  final String? visitId;
  final String initialNotes;
  final Function(String)? onNotesChanged;
  final bool openWithCreateHorsePage;
  final bool openWithManagementHorsePage;
  final bool openWithCreateClientPage;
  final String proID;
  final String? customId;
  final String? horseId;

  const NotesCardWidget({
    Key? key,
    this.visitId,
    required this.initialNotes,
    required this.openWithCreateHorsePage,
    required this.openWithCreateClientPage,
    required this.openWithManagementHorsePage,
    required this.proID,
    this.customId,
    this.onNotesChanged,
    this.horseId,
  }) : super(key: key);

  @override
  _NotesCardWidgetState createState() => _NotesCardWidgetState();
}

class _NotesCardWidgetState extends State<NotesCardWidget> {
  bool _isEditing = false;
  late TextEditingController _notesController;
  late String _originalNotes;

  @override
  void initState() {
    super.initState();
        _originalNotes = widget.initialNotes;
    _notesController = TextEditingController(text: widget.initialNotes);

    if (widget.openWithCreateHorsePage || widget.openWithCreateClientPage) {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

@override
void didUpdateWidget(covariant NotesCardWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  // On met à jour seulement si le contenu est différent ET qu'on n'est pas en train d’éditer
  if (!_isEditing && oldWidget.initialNotes != widget.initialNotes) {
    _notesController.text = widget.initialNotes;
    _originalNotes = widget.initialNotes;
  }
}



  Future<void> _handleSave() async {
    final newNotes = _notesController.text.trim();

    if (newNotes == _originalNotes) {
      setState(() => _isEditing = false);
      return;
    }

    if (widget.onNotesChanged != null) {
      widget.onNotesChanged!(newNotes);
    }

    if (widget.openWithManagementHorsePage) {
      await updateNotesHorse(notes: newNotes);
    } else {
      if (widget.visitId != null) {
        await updateNotes(visitId: widget.visitId!, notes: newNotes);
      } else {
        await updateNotes(visitId: null, notes: newNotes);
      }
    }
    setState(() {
      _originalNotes = newNotes;
      _isEditing = false;
      if (widget.onNotesChanged != null) {
      widget.onNotesChanged!(newNotes);
    }
    });
  }

Future<void> updateNotesHorse({
  required String notes,
}) async {
  final url = '${Constants.apiBaseUrl}/horse/${widget.horseId}/notes';
  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'notes': notes,
      }),
    );

    if (response.statusCode == 200) {
      print('Notes cheval mises à jour avec succès.');
    } else {
      print('Erreur lors de la mise à jour des notes cheval : ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Erreur réseau lors de la mise à jour des notes cheval : $e');
  }
}


  
Future<void> updateNotes({
    required String? visitId,
    required String notes,
  }) async {
    final url = visitId == null
        ? '${Constants.apiBaseUrl}/note' // création
        : '${Constants.apiBaseUrl}/note/$visitId'; // mise à jour

    final method = visitId == null ? 'POST' : 'PUT';

    final body = visitId == null
        ? jsonEncode({
            'customer_id': widget.customId,
            'professionals_id': widget.proID,
            'notes': notes,
          })
        : jsonEncode({'notes': notes});

    try {
      final response = await http.Request(method, Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final streamedResponse = await response.send();
      final res = await http.Response.fromStream(streamedResponse);

      if (res.statusCode == 200 || res.statusCode == 201) {
        print('Notes mises à jour avec succès.');
        // Optionnel : fetch des données mises à jour
        //await _fetchLastAppointmentBetweenProAndCustomer();
      } else {
        print('Erreur lors de la mise à jour des notes : ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      print('Erreur réseau lors de la mise à jour des notes : $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Commentaire',
                labelStyle: const TextStyle(color: Constants.white),
                fillColor: Constants.white.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
              ),
              style: const TextStyle(color: Constants.white),
              cursorColor: Constants.white,
              maxLines: 5,
              readOnly: !_isEditing,
              maxLength: 500,

              onChanged: (text) {
                if (widget.onNotesChanged != null) {
                  widget.onNotesChanged!(text);
                }
              },
            ),
            const SizedBox(height: 16),
            if (!widget.openWithCreateHorsePage && !widget.openWithCreateClientPage)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _notesController.text = _originalNotes;
                          _isEditing = false;
                        });
                      },
                      child: const Text('Annuler',style: TextStyle(color: Constants.appBarBackgroundColor)),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_isEditing) {
                        await _handleSave();
                      } else {
                        setState(() => _isEditing = true);
                      }
                    },
                    child: Text(_isEditing ? 'Enregistrer' : 'Modifier',style: TextStyle(color: Constants.appBarBackgroundColor)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
