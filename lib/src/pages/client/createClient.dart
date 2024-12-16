import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/src/widgets/form/clientFormWidget.dart';

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
          child: ClientFormWidget(
            formKey: _formKey,
            onSavedNom: (value) => nom = value!,
            onSavedPrenom: (value) => prenom = value!,
            onSavedTel: (value) => tel = value!,
            onSavedMobile: (value) => mobile = value!,
            onSavedEmail: (value) => email = value!,
            onSavedAdressePerso: (value) => adressePerso = value!,
            onSavedAdresseEcuries: (value) => adresseEcuries = value!,
            onSavedVille: (value) => ville = value!,
            onSavedRegion: (value) => region = value!,
            onSavedDate: (value) => derniereVisite = value,
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
