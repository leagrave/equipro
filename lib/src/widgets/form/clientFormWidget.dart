import 'package:flutter/material.dart';

class ClientFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String?) onSavedNom;
  final void Function(String?) onSavedPrenom;
  final void Function(String?) onSavedTel;
  final void Function(String?) onSavedMobile;
  final void Function(String?) onSavedEmail;
  final void Function(String?) onSavedAdressePerso;
  final void Function(String?) onSavedAdresseEcuries;
  final void Function(String?) onSavedVille;
  final void Function(String?) onSavedRegion;
  final void Function(DateTime) onSavedDate;

  ClientFormWidget({
    required this.formKey,
    required this.onSavedNom,
    required this.onSavedPrenom,
    required this.onSavedTel,
    required this.onSavedMobile,
    required this.onSavedEmail,
    required this.onSavedAdressePerso,
    required this.onSavedAdresseEcuries,
    required this.onSavedVille,
    required this.onSavedRegion,
    required this.onSavedDate,
  });

  @override
  _ClientFormWidgetState createState() => _ClientFormWidgetState();
}

class _ClientFormWidgetState extends State<ClientFormWidget> {
  DateTime derniereVisite = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          // Nom
          buildTextFormField(
            label: 'Nom',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom';
              }
              return null;
            },
            onSaved: widget.onSavedNom,
          ),
          // Prénom
          buildTextFormField(
            label: 'Prénom',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un prénom';
              }
              return null;
            },
            onSaved: widget.onSavedPrenom,
          ),
          // Téléphone
          buildTextFormField(
            label: 'Téléphone',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un téléphone';
              }
              return null;
            },
            onSaved: widget.onSavedTel,
          ),
          // Mobile
          buildTextFormField(
            label: 'Mobile',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un mobile';
              }
              return null;
            },
            onSaved: widget.onSavedMobile,
          ),
          // Email
          buildTextFormField(
            label: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un email';
              }
              return null;
            },
            onSaved: widget.onSavedEmail,
          ),
          // Adresse personnelle
          buildTextFormField(
            label: 'Adresse personnelle',
            onSaved: widget.onSavedAdressePerso,
          ),
          // Adresse des écuries
          buildTextFormField(
            label: 'Adresse des écuries',
            onSaved: widget.onSavedAdresseEcuries,
          ),
          // Ville
          buildTextFormField(
            label: 'Ville',
            onSaved: widget.onSavedVille,
          ),
          // Région
          buildTextFormField(
            label: 'Région',
            onSaved: widget.onSavedRegion,
          ),
          // Dernière visite (date)
          Row(
            children: [
              Text(
                "Dernière visite : ${derniereVisite.toLocal()}".split(' ')[0],
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: derniereVisite,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != derniereVisite)
                    setState(() {
                      derniereVisite = picked;
                    });
                  widget.onSavedDate(derniereVisite); 
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fonction pour créer un champ de formulaire stylisé
  Widget buildTextFormField({
    required String label,
    String? Function(String?)? validator,
    required void Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: TextStyle(color: Colors.black),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
