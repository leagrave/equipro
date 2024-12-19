import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/src/widgets/form/clientFormWidget.dart';
import 'package:equipro/src/widgets/card/clientCardWidget.dart';  
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/clientAdresseCardWidget.dart';

class CreateClientPage extends StatefulWidget {
  @override
  _CreateClientPageState createState() => _CreateClientPageState();
}

class _CreateClientPageState extends State<CreateClientPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String prenom = '';
  String tel = '';
  String mobile = '';
  String email = '';
  String adressePerso = '';
  String adresseEcuries = '';
  String ville = '';
  String region = '';
  DateTime derniereVisite = DateTime.now();
  bool isSociete = false;

  // Variable pour les notes et adresses
  String clientNotes = '';
  List<String> clientAddresses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Créer un client',
        logoPath: 'assets/images/image-logo.jpg',
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClientCardWidget(
                  initialName: nom,
                  initialSurname: prenom,
                  tel: tel,
                  email: email,
                  isSociete: isSociete,
                  onNameChanged: (value) => setState(() => nom = value),
                  onSurnameChanged: (value) => setState(() => prenom = value),
                  onTelChanged: (value) => setState(() => tel = value),
                  onEmailChanged: (value) => setState(() => email = value),
                  onIsSocieteChanged: (value) => setState(() => isSociete = value),
                ),
                SizedBox(height: 16),
                ClientNotesCardWidget(
                  initialNotes: clientNotes,
                  onNotesChanged: (value) => setState(() => clientNotes = value),
                ),
                SizedBox(height: 16),
                AddressCardWidget(
                  addresses: clientAddresses,
                  location: Location(latitude: 0.0, longitude: 0.0), // Passer une localisation vide pour l'instant
                  onAdresseChanged: (value) => setState(() => clientAddresses = value.split(',')), // Simple split en utilisant la virgule pour séparer les adresses
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final newClient = Client(
              nom: nom,
              prenom: prenom,
              tel: tel,
              mobile: mobile,
              email: email,
              adresse: adressePerso,
              adresseFacturation: adresseEcuries,
              ville: ville,
              region: region,
              derniereVisite: derniereVisite,
            );
            Navigator.pop(context, newClient); // Retourner le nouveau client
          }
        },
        child: Icon(Icons.save),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      bottomNavigationBar: MyWidgetBottomNavBar(
        onTap: (index) {
          // Navigation selon l'index sélectionné
        },
      ),
    );
  }
}
