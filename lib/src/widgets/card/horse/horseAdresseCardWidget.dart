import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}

class HorseAddressCardWidget extends StatefulWidget {
  final String address; 
  final Location location;
  final Function(String)? onAddressChanged;
  final bool openWithCreateHorsePage;

  const HorseAddressCardWidget({
    Key? key,
    required this.address,
    required this.location,
    this.onAddressChanged,
    required this.openWithCreateHorsePage,
  }) : super(key: key);

  @override
  _HorseAddressCardWidgetState createState() =>
      _HorseAddressCardWidgetState();
}

class _HorseAddressCardWidgetState extends State<HorseAddressCardWidget> {
  bool _isEditing = false;
  late TextEditingController _addressController;
  late String _originalAddress; 
  bool openWithCreateHorsePage = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.address);
    _originalAddress = widget.address; 

    if (widget.openWithCreateHorsePage == true) {
      setState(() {
         _isEditing = !_isEditing;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Adresse écurie',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: _addressController,
                      onChanged: widget.onAddressChanged,
                      readOnly: !_isEditing, 
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.place),
                    onPressed: () {
                      final googleMapsUrl =
                          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_addressController.text)}';
                      launchUrl(Uri.parse(googleMapsUrl));
                    },
                    color: const Color.fromARGB(255, 219, 27, 27), 
                  ),
                ],
              ),
              const SizedBox(height: 16),


              // Boutons "Annuler" et "Enregistrer"
              if (!widget.openWithCreateHorsePage)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing) ...[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _addressController.text = _originalAddress; 
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
                          // Sauvegarder les modifications si en mode édition
                          if (widget.onAddressChanged != null) {
                            widget.onAddressChanged!(_addressController.text);
                          }
                        }
                        // Si le bouton "Annuler" a été pressé, on ne change pas _originalAddress
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
