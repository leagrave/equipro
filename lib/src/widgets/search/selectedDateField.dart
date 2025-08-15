import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater la date

class SelectedDateField extends StatefulWidget {
  final DateTime? selectedDate;
  final bool enabled;
  final String label;
  final Function(DateTime) onDateSelected;

  const SelectedDateField({
    Key? key,
    required this.selectedDate,
    required this.enabled,
    required this.label,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _SelectedDateFieldState createState() => _SelectedDateFieldState();
}

class _SelectedDateFieldState extends State<SelectedDateField> {
  late TextEditingController _controller;
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('dd/MM/yyyy');
    _controller = TextEditingController(
      text: widget.selectedDate != null ? _dateFormat.format(widget.selectedDate!) : '',
    );
  }

  @override
  void didUpdateWidget(covariant SelectedDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Met à jour le contrôleur si la date change de l’extérieur
    if (oldWidget.selectedDate != widget.selectedDate) {
      _controller.text = widget.selectedDate != null ? _dateFormat.format(widget.selectedDate!) : '';
    }
  }

  Future<void> _selectDate() async {
    if (!widget.enabled) return; // Désactive la sélection si non activé

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('fr'),
    );

    if (pickedDate != null) {
      _controller.text = _dateFormat.format(pickedDate);
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabled: widget.enabled,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
