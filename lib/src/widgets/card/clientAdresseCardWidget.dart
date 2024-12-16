import 'package:equipro/style/appColor.dart';
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

  const AddressCardWidget({
    Key? key,
    required this.addresses, 
    required this.location,
    this.onAdresseChanged,
  }) : super(key: key);

  @override
  _AddressCardWidgetState createState() => _AddressCardWidgetState();
}

class _AddressCardWidgetState extends State<AddressCardWidget> {

  @override
  Widget build(BuildContext context) {
    final addresses = widget.addresses ?? []; // Utiliser une liste vide si null

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
            children: [
              // Affichage des adresses avec labelText conditionnels
              for (int i = 0; i < addresses.length; i++) 
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
                                      : 'Autres adresses', // Modifier le labelText en fonction de l'indice
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            controller: TextEditingController(text: addresses[i]),
                            onChanged: widget.onAdresseChanged,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.place),
                          onPressed: () {
                            final googleMapsUrl =
                                'https://www.google.com/maps/search/?api=1&query=${widget.location.latitude},${widget.location.longitude}';
                            launchUrl(Uri.parse(googleMapsUrl));
                          },
                          color: const Color.fromARGB(255, 219, 27, 27), // Couleur de l'icône
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              
              // Bouton pour ajouter une adresse
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: TextButton(
              //     onPressed: () {
              //       // Logique pour ajouter une adresse
              //     },
              //     child: Text('Ajouter une adresse'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
