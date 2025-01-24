import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Classe représentant une position géographique avec latitude et longitude
class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}

class AddressCardWidget extends StatefulWidget {
  final List<String>? addresses;
  final Location location;
  final Function(String)? onAdresseChanged;
  final bool openWithCreateClientPage;

  const AddressCardWidget({
    Key? key,
    required this.addresses,
    required this.location,
    required this.openWithCreateClientPage,
    this.onAdresseChanged,
  }) : super(key: key);

  @override
  _AddressCardWidgetState createState() => _AddressCardWidgetState();
}

class _AddressCardWidgetState extends State<AddressCardWidget> {
  late List<TextEditingController> _addressControllers;
  late List<bool> _isEditing;

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs avec les adresses
    _addressControllers = widget.addresses?.map((address) {
      return TextEditingController(text: address);
    }).toList() ?? [];

    // Initialiser l'état de l'édition pour chaque adresse (false par défaut)
    _isEditing = List.generate(widget.addresses?.length ?? 0, (index) => false);

    if (widget.openWithCreateClientPage) {
      setState(() {
        // Initialisation de l'édition pour afficher les champs vide
        _isEditing = List.generate(_addressControllers.length + 2, (index) => true);
        _addressControllers.add(TextEditingController());  
        _addressControllers.add(TextEditingController());  
      });
    }
  }

  @override
  void dispose() {
    // Libérer les contrôleurs lorsque le widget est détruit
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addresses = widget.addresses ?? [];

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
              // Affichage des adresses avec labelText conditionnels
              for (int i = 0; i < _addressControllers.length; i++) 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: i == 0
                                  ? 'Adresse'
                                  : i == 1
                                      ? 'Adresse de facturation'
                                      : i == 2
                                          ? 'Autres adresses' 
                                          : 'Autre adresse', 
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            controller: _addressControllers[i],
                            onChanged: widget.onAdresseChanged,
                            readOnly: !_isEditing[i], 
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.place),
                          onPressed: () {
                            final googleMapsUrl =
                                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_addressControllers[i].text)}';
                            launchUrl(Uri.parse(googleMapsUrl));
                          },
                          color: const Color.fromARGB(255, 219, 27, 27),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),

              if(!widget.openWithCreateClientPage)
              // Boutons "Modifier", "Annuler" et "Enregistrer" en dehors de la boucle
              if (_isEditing.contains(true)) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Réinitialiser tous les champs à leur valeur d'origine
                          for (int i = 0; i < addresses.length; i++) {
                            _addressControllers[i].text = addresses[i];
                          }
                          _isEditing = List.generate(addresses.length, (index) => false); 
                        });
                      },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Sauvegarder les modifications pour chaque champ
                          if (widget.onAdresseChanged != null) {
                            for (int i = 0; i < addresses.length; i++) {
                              widget.onAdresseChanged!(_addressControllers[i].text);
                            }
                          }
                          _isEditing = List.generate(addresses.length, (index) => false); 
                        });
                      },
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ] else ...[
                // Si aucun champ n'est en mode édition, afficher "Modifier"
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = List.generate(addresses.length, (index) => true); 
                        });
                      },
                      child: const Text('Modifier'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
