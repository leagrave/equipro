import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/ecurie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EcurieCardWidget extends StatefulWidget {
  final String proID;
  final Ecurie ecurie;
  final Function(Ecurie updated) onUpdated;
  final VoidCallback onSave;
  final bool openWithCreateHorsePage;

  const EcurieCardWidget({
    Key? key,
    required this.proID,
    required this.ecurie,
    required this.onUpdated,
    required this.onSave,
    required this.openWithCreateHorsePage,
  }) : super(key: key);

  @override
  _EcurieCardWidgetState createState() => _EcurieCardWidgetState();
}

class _EcurieCardWidgetState extends State<EcurieCardWidget> {
  late TextEditingController _nameController;
  late TextEditingController _userIdController;
  late TextEditingController _addressIdController;
  late TextEditingController _phoneController;
  late TextEditingController _phone2Controller;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ecurie.name);
    _userIdController = TextEditingController(text: widget.ecurie.user_id);
    _addressIdController = TextEditingController(text: widget.ecurie.addressId ?? '');
    _phoneController = TextEditingController(text: widget.ecurie.phone ?? '');
    _phone2Controller = TextEditingController(text: widget.ecurie.phone2 ?? '');

        if (widget.openWithCreateHorsePage) {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userIdController.dispose();
    _addressIdController.dispose();
    _phoneController.dispose();
    _phone2Controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _cancelEdit() {
    setState(() {
      _nameController.text = widget.ecurie.name;
      _userIdController.text = widget.ecurie.user_id;
      _addressIdController.text = widget.ecurie.addressId ?? '';
      _phoneController.text = widget.ecurie.phone ?? '';
      _phone2Controller.text = widget.ecurie.phone2 ?? '';
      _isEditing = false;
    });
  }

  void _saveChanges() {
    final updated = widget.ecurie.copyWith(
      name: _nameController.text,
      user_id: _userIdController.text,
      addressId: _addressIdController.text.isNotEmpty ? _addressIdController.text : null,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      phone2: _phone2Controller.text.isNotEmpty ? _phone2Controller.text : null,
    );

    widget.onUpdated(updated);
    widget.onSave();
    _toggleEdit();
  }

  Future<void> _onCreate() async {
    setState(() {
      _isLoading = true;
    });

    final data = {
      "name": _nameController.text,
      "user_id": _userIdController.text, 
      "address_id": _addressIdController.text.isNotEmpty ? _addressIdController.text : null,
      "phone": _phoneController.text.isNotEmpty ? _phoneController.text : null,
      "phone2": _phone2Controller.text.isNotEmpty ? _phone2Controller.text : null,
    };

    try {
      final response = await ApiService.postWithAuth("/stables/by-owner/${widget.proID}", data,);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final createdEcurie = Ecurie.fromJson(jsonResponse);

        widget.onUpdated(createdEcurie);
        widget.onSave();

        setState(() {
          _isEditing = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Écurie créée avec succès')),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création : ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau : $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Nom de l’écurie", _nameController),
              const SizedBox(height: 8),
              _buildTextField("ID Propriétaire", _userIdController),
              const SizedBox(height: 8),
              _buildTextField("ID Adresse", _addressIdController),
              const SizedBox(height: 8),
              _buildTextField("Téléphone", _phoneController),
              const SizedBox(height: 8),
              _buildTextField("Téléphone secondaire", _phone2Controller),
              const SizedBox(height: 8),
              _buildActionButtons(),
            ],
          ),
        ),
      );
  }

  Widget _buildTextField(String label, TextEditingController controller, {IconData? icon}) {
    return TextField(
      controller: controller,
      readOnly: !_isEditing,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildActionButtons() {
    if (widget.openWithCreateHorsePage) {
      // En mode création, afficher uniquement un bouton sauvegarder à droite
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _onCreate,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sauvegarder',
              style: TextStyle(color: Constants.appBarBackgroundColor),
            ),
          ),

        ],
      );
    }

    if (_isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _cancelEdit,
            child: const Text('Annuler', style: TextStyle(color: Constants.appBarBackgroundColor)),
          ),
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Sauvegarder', style: TextStyle(color: Constants.appBarBackgroundColor)),
          ),
        ],
      );
    } else {
      return TextButton(
        onPressed: _toggleEdit,
        child: const Text('Modifier', style: TextStyle(color: Constants.appBarBackgroundColor)),
      );
    }
  }

}
