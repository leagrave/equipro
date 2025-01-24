import 'package:flutter/material.dart';

class NotesCardWidget extends StatefulWidget {
  final String initialNotes;
  final Function(String)? onNotesChanged;
  final bool openWithCreateHorsePage;

  const NotesCardWidget({
    Key? key,
    required this.initialNotes,
    required this.openWithCreateHorsePage,
    this.onNotesChanged,
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
    _notesController = TextEditingController(text: widget.initialNotes);
    _originalNotes = widget.initialNotes;

    if (widget.openWithCreateHorsePage == true) {
      setState(() {
        _isEditing = true;
      });
    }
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
        color: Colors.white.withOpacity(0.8),
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
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Commentaires',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: widget.onNotesChanged,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLength: 500,
                readOnly: !_isEditing,
              ),
              const SizedBox(height: 16),

              if (!widget.openWithCreateHorsePage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isEditing) ...[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _notesController.text = _originalNotes;
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
                          if (_isEditing) {
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
