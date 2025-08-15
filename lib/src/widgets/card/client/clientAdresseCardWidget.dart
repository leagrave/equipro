import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressCardWidget extends StatefulWidget {
  final List<Address>? addresses;
  final Function(List<Address>)? onAdresseChanged;
  final bool openWithCreateClientPage;
  final bool openWithCreateHorsePage;
  final bool openWithManagementHorsePage;
  final Function()? onSave;
  final Function(Map<String, dynamic>)? onChanged;
  final String? userSelectedId;
  final String? horseSelectedId;


  const AddressCardWidget({
    Key? key,
    required this.addresses,
    this.userSelectedId,
    this.horseSelectedId,
    required this.openWithCreateClientPage,
    required this.openWithCreateHorsePage,
    required this.openWithManagementHorsePage,
    this.onAdresseChanged,
    this.onSave,
    this.onChanged,
  }) : super(key: key);

  @override
  _AddressCardWidgetState createState() => _AddressCardWidgetState();
}

class _AddressCardWidgetState extends State<AddressCardWidget> {
  late List<Address> _addresses;


  late TextEditingController _idController;
  late TextEditingController _adresseController;
  late TextEditingController _postalController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _typeController;

  late TextEditingController _idFacturationController;
  late TextEditingController _adresseFacturationController;
  late TextEditingController _postalFacturationController;
  late TextEditingController _cityFacturationController;
  late TextEditingController _countryFacturationController;
  late TextEditingController _typeFacturationController;

  bool _isEditingAdresse = false;

  @override
  void initState() {
    super.initState();

    _addresses = List<Address>.filled(2, Address.empty(), growable: false);

    final adresses = widget.addresses ?? [];
    final adressePrincipale = adresses.firstWhere(
      (a) => a.type == 'main' ,
      orElse: () => Address.empty(),
    );

    final adresseFacturation = adresses.firstWhere(
      (a) => a.type == 'billing',
      orElse: () => Address.empty(),
    );

    // Adresse principale
    _idController = TextEditingController(text: adressePrincipale.idAddress);
    _adresseController = TextEditingController(text: adressePrincipale.address);
    _postalController = TextEditingController(text: adressePrincipale.postalCode);
    _cityController = TextEditingController(text: adressePrincipale.city);
    _countryController = TextEditingController(text: adressePrincipale.country);
    _typeController = TextEditingController(text: adressePrincipale.type);

    // Adresse de facturation
    _idFacturationController = TextEditingController(text: adresseFacturation.idAddress);
    _adresseFacturationController = TextEditingController(text: adresseFacturation.address);
    _postalFacturationController = TextEditingController(text: adresseFacturation.postalCode);
    _cityFacturationController = TextEditingController(text: adresseFacturation.city);
    _countryFacturationController = TextEditingController(text: adresseFacturation.country);
    _typeFacturationController = TextEditingController(text: adresseFacturation.type);

  // Détermine le mode édition selon les conditions
  // if (widget.openWithManagementHorsePage) {
  //   _isEditingAdresse = false;
  // } else 
  if (widget.openWithCreateClientPage || widget.openWithCreateHorsePage) {
    _isEditingAdresse = true;
  } else {
    _isEditingAdresse = false;
  }


  }

  @override
  void dispose() {
    for (final c in [
      _idController,_adresseController, _postalController, _cityController, _countryController, _typeController,
      _idFacturationController,_adresseFacturationController, _postalFacturationController, _cityFacturationController,
      _countryFacturationController, _typeFacturationController
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<bool> _validateForm() async {
    // if (_adresseController.text.trim().isEmpty ||
    //     _postalController.text.trim().isEmpty ||
    //     _cityController.text.trim().isEmpty ||
    //     _countryController.text.trim().isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Tous les champs de l'adresse principale doivent être remplis.")),
    //   );
    //   return false;
    // }

    // if (_adresseFacturationController.text.trim().isEmpty ||
    //     _postalFacturationController.text.trim().isEmpty ||
    //     _cityFacturationController.text.trim().isEmpty ||
    //     _countryFacturationController.text.trim().isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Tous les champs de l'adresse de facturation doivent être remplis.")),
    //   );
    //   return false;
    // }

    return true;
  }

Future<void> _validerEtMettreAJourAdressesUser() async {
  if (!await _validateForm()) return;

  final addressesToUpdate = [
    Address(
      idAddress: _idController.text.trim(),
      address: _adresseController.text.trim(),
      postalCode: _postalController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      type: _typeController.text.trim(),
    ),
    Address(
      idAddress: _idFacturationController.text.trim(),
      address: _adresseFacturationController.text.trim(),
      postalCode: _postalFacturationController.text.trim(),
      city: _cityFacturationController.text.trim(),
      country: _countryFacturationController.text.trim(),
      type: _typeFacturationController.text.trim(),
    )
  ];

  bool success = true;

  for (final address in addressesToUpdate) {
    final hasMinimumFields =
        address.address.trim().isNotEmpty &&
        address.city.trim().isNotEmpty &&
        address.postalCode.trim().isNotEmpty;

    if (!hasMinimumFields) {
      debugPrint("Adresse de type ${address.type} ignorée car incomplète.");
      continue;
    }

    final isNew = address.idAddress.isEmpty;

    final body = {
      'address': address.address,
      'postal_code': address.postalCode,
      'city': address.city,
      'country': address.country,
      'latitude': null,
      'longitude': null,
      'type': address.type,
      'user_id': widget.userSelectedId,
      'horse_id': null,
    };

    try {
      final response = isNew
          ? await ApiService.postWithAuth('/adresses', body)
          : await ApiService.putWithAuth('/adresses/${address.idAddress}', body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        success = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur lors de la ${isNew ? 'création' : 'mise à jour'} de l'adresse : ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      success = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur réseau : $e")),
      );
    }
  }

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Adresses enregistrées avec succès.")),
    );
  }
}


Future<void> _validerEtMettreAJourAdressesHorse() async {
  if (!await _validateForm()) return;

  final addressesToUpdate = [
    Address(
      idAddress: _idController.text.trim(),
      address: _adresseController.text.trim(),
      postalCode: _postalController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      type: _typeController.text.trim(),
    ),
  ];

  bool success = true;

  for (final address in addressesToUpdate) {
    final hasMinimumFields =
        address.address.trim().isNotEmpty &&
        address.city.trim().isNotEmpty &&
        address.postalCode.trim().isNotEmpty;

    if (!hasMinimumFields) {
      debugPrint("Adresse de type ${address.type} ignorée car incomplète.");
      continue;
    }

    final isNew = address.idAddress.isEmpty;

    final body = {
      'address': address.address,
      'postal_code': address.postalCode,
      'city': address.city,
      'country': address.country,
      'latitude': null,
      'longitude': null,
      'type': address.type,
      'user_id': null,
      'horse_id': widget.horseSelectedId,
    };

    try {
      final response = isNew
          ? await ApiService.postWithAuth('/adresses', body)
          : await ApiService.putWithAuth('/adresses/${address.idAddress}', body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        success = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur lors de la ${isNew ? 'création' : 'mise à jour'} de l'adresse : ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      success = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur réseau : $e")),
      );
    }
  }

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Adresses enregistrées avec succès.")),
    );
  }
}




 void _handleSaveOrCancel({required bool isSave}) {
  if (isSave) {
    if(!(widget.openWithManagementHorsePage || widget.openWithCreateHorsePage))
      _validerEtMettreAJourAdressesHorse();
      // if((widget.openWithManagementHorsePage || widget.openWithCreateHorsePage))
      // _validerEtMettreAJourAdressesUser();
    widget.onSave?.call();
  } else {
    // Restaure les données initiales à partir de widget.addresses
    final adresses = widget.addresses ?? [];
    final adressePrincipale = adresses.isNotEmpty ? adresses.first : Address.empty();
    final adresseFacturation = adresses.length > 1 ? adresses[1] : Address.empty();

    _idController.text = adressePrincipale.idAddress ?? '';
    _adresseController.text = adressePrincipale.address;
    _postalController.text = adressePrincipale.postalCode;
    _cityController.text = adressePrincipale.city;
    _countryController.text = adressePrincipale.country;


    _idFacturationController.text = adresseFacturation.idAddress ?? '';
    _adresseFacturationController.text = adresseFacturation.address;
    _postalFacturationController.text = adresseFacturation.postalCode;
    _cityFacturationController.text = adresseFacturation.city;
    _countryFacturationController.text = adresseFacturation.country;

  }

  setState(() {
    _isEditingAdresse = false;
  });
}

  void _updateAddress({
    required int index,
    String? idAddress,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? type,
  }) {
    setState(() {
      final updatedAddresses = List<Address>.from(_addresses);
      final oldAddress = updatedAddresses[index];
      updatedAddresses[index] = oldAddress.copyWith(
        idAddress: idAddress ?? oldAddress.idAddress,
        address: address ?? oldAddress.address,
        city: city ?? oldAddress.city,
        postalCode: postalCode ?? oldAddress.postalCode,
        country: country ?? oldAddress.country,
        latitude: latitude ?? oldAddress.latitude,
        longitude: longitude ?? oldAddress.longitude,
        type: type ?? oldAddress.type,
      );
      _addresses = updatedAddresses;
    });

    widget.onAdresseChanged?.call(_addresses);
    widget.onSave?.call();
  }


Widget buildStyledTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  ValueChanged<String>? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      readOnly: !_isEditingAdresse,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
    ),
  );
}

Widget buildStyledDisplayField({
  required String value,
  required String label,
  required IconData icon,
  void Function()? onSuffixTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    
    child: TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: onSuffixTap != null
            ? IconButton(
                icon: const Icon(Icons.place, color: Colors.red),
                onPressed: onSuffixTap,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    ),
  );
}


@override
Widget build(BuildContext context) {
  debugPrint("build triggered, _isEditingAdresse: $_isEditingAdresse");
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isEditingAdresse ? _buildFieldsPrincipal() : _buildTextDisplayPrincipal(),
        const Divider(height: 16),

        if (!(widget.openWithCreateHorsePage || widget.openWithManagementHorsePage))
          _isEditingAdresse ? _buildFieldsFacturation() : _buildTextDisplayFacturation(),


            if(!(widget.openWithCreateClientPage || widget.openWithCreateHorsePage))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditingAdresse)
                    ElevatedButton(
                      onPressed: () => _handleSaveOrCancel(isSave: false),
                      child: const Text('Annuler', style: TextStyle(color: Constants.appBarBackgroundColor),),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_isEditingAdresse) {
                        _handleSaveOrCancel(isSave: true);
                      } else {
                        setState(() {
                          _isEditingAdresse = true;
                        });
                      }
                    },
                    child: Text(_isEditingAdresse ? 'Enregistrer' : 'Modifier',style: TextStyle(color: Constants.appBarBackgroundColor),),
                  ),
                ],
              ),
      ],
    ),
  );
}


  Widget _buildField(TextEditingController controller, String label, IconData icon, {ValueChanged<String>? onChanged}) {
    return buildStyledTextField(
      controller: controller,
      label: label,
      icon: icon,
      onChanged: onChanged,
    );
  }


  Widget _buildFieldsPrincipal() {
    return Column(
      children: [
        _buildField(_adresseController, "Adresse", Icons.home, onChanged: (value) => _updateAddress(index: 0, address: value)),
        _buildField(_postalController, "Code Postal", Icons.local_post_office, onChanged: (value) => _updateAddress(index: 0,postalCode: value)),
        _buildField(_cityController, "Ville", Icons.location_city, onChanged: (value) => _updateAddress(index: 0,city: value)),
        _buildField(_countryController, "Pays", Icons.flag,  onChanged: (value) => _updateAddress(index: 0,country: value)),
        _buildField(_typeController, "Type", Icons.info_outline, onChanged: (value) => _updateAddress(index: 0,type: value)),
      ],
    );
  }


  Widget _buildFieldsFacturation() {
    return Column(
      children: [
        _buildField(_adresseFacturationController, "Adresse Facturation", Icons.home_outlined,  onChanged: (value) => _updateAddress(index: 1,address: value)),
        _buildField(_postalFacturationController, "Code Postal Facturation", Icons.markunread_mailbox,  onChanged: (value) => _updateAddress(index: 1,postalCode: value)),
        _buildField(_cityFacturationController, "Ville Facturation", Icons.location_city_outlined,  onChanged: (value) => _updateAddress(index: 1,city: value)),
        _buildField(_countryFacturationController, "Pays Facturation", Icons.flag_outlined, onChanged: (value) => _updateAddress(index: 1,country: value)),
        _buildField(_typeFacturationController, "Type", Icons.info_outline, onChanged: (value) => _updateAddress(index: 1,type: value)),
      ],
    );
  }


  Widget _buildTextDisplayPrincipal() {
    final address = '${_adresseController.text} ${_postalController.text} ${_cityController.text} ${_countryController.text}';
    return buildStyledDisplayField(
      value: address,
      label: "Adresse",
      icon: Icons.home,
      onSuffixTap: () {
        final query = Uri.encodeComponent(address);
        final url = 'https://www.google.com/maps/search/?api=1&query=$query';
        launchUrl(Uri.parse(url));
      },
    );
  }

  Widget _buildTextDisplayFacturation() {
    final address = '${_adresseFacturationController.text} ${_postalFacturationController.text} ${_cityFacturationController.text} ${_countryFacturationController.text}';
    return buildStyledDisplayField(
      value: address,
      label: "Adresse de facturation",
      icon: Icons.home_outlined,
      onSuffixTap: () {
        final query = Uri.encodeComponent(address);
        final url = 'https://www.google.com/maps/search/?api=1&query=$query';
        launchUrl(Uri.parse(url));
      },
    );
  }

}
