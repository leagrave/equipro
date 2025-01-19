import 'package:flutter/material.dart';

class HorseFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String?)? onSavedName;
  final Function(String?)? onSavedRace;
  final Function(String?)? onSavedAge;
  final Function(String?)? onSavedColor;
  final Function(String?)? onSavedFeedingType;
  final Function(String?)? onSavedActivityType;
  final Function(DateTime?)? onSavedLastVisitDate;

  const HorseFormWidget({
    Key? key,
    required this.formKey,
    this.onSavedName,
    this.onSavedRace,
    this.onSavedAge,
    this.onSavedColor,
    this.onSavedFeedingType,
    this.onSavedActivityType,
    this.onSavedLastVisitDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          // Champ Nom
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Nom requis' : null,
            onSaved: onSavedName,
          ),
          const SizedBox(height: 8),

          // Champ Race
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Race',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Race requise' : null,
            onSaved: onSavedRace,
          ),
          const SizedBox(height: 8),

          // Champ Âge
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Âge',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              final age = int.tryParse(value ?? '');
              return age == null || age <= 0 ? 'Âge invalide' : null;
            },
            onSaved: onSavedAge,
          ),
          const SizedBox(height: 8),

          // Champ Couleur
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Couleur',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSaved: onSavedColor,
          ),
          const SizedBox(height: 8),

          // Champ Type d'alimentation
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Type d\'alimentation',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSaved: onSavedFeedingType,
          ),
          const SizedBox(height: 8),

          // Champ Type d'activité
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Type d\'activité',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSaved: onSavedActivityType,
          ),
          const SizedBox(height: 8),

          // Champ Dernière visite avec un DatePicker (optionnel)
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                onSavedLastVisitDate?.call(selectedDate); // Appel de onSavedLastVisitDate
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Dernière visite',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSaved: (value) {}, // Pas de `onSaved` direct ici, car la date est capturée par un `onTap`.
                controller: TextEditingController(text: ''), // Ce champ ne change pas directement
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
