import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';  
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';

class CreateClientPage extends StatefulWidget {
  @override
  _CreateClientPageState createState() => _CreateClientPageState();
}

class _CreateClientPageState extends State<CreateClientPage> {
  final _formKey = GlobalKey<FormState>();
  int idClient = 0;
  String nom = '';
  String prenom = '';
  String tel = '';
  String tel2 = '';
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
      appBar: const MyWidgetAppBar(
        title: 'Créer un client',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:[Constants.appBarBackgroundColor, Constants.appBarBackgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClientCardWidget(
                  client: Client(
                    idClient: 4,  
                    nom: nom,    
                    prenom: prenom,
                    tel: tel,  
                    email: email, 
                    isSociete: isSociete, 
                  ),
                  onClientUpdated: (updatedClient) {
                    setState(() {
                      nom = updatedClient.nom;
                      prenom = updatedClient.prenom;
                      tel = updatedClient.tel;
                      email = updatedClient.email ?? "";
                      isSociete = updatedClient.isSociete ?? false;
                    });
                  },
                  openWithCreateClientPage: true, 
                  openWithCreateHorsePage: false,
                ),
                SizedBox(height: 16),
                AddressCardWidget(
                  addresses: clientAddresses,
                  location: Location(latitude: 0.0, longitude: 0.0),
                  onAdresseChanged: (value) => setState(() => clientAddresses = value.split(',')), 
                  openWithCreateClientPage: true,
                ),
                SizedBox(height: 16),
                NotesCardWidget(
                  initialNotes: clientNotes,
                  onNotesChanged: (value) => setState(() => clientNotes = value),
                  openWithCreateHorsePage: false,
                  openWithCreateClientPage: true,
                )
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
              idClient: idClient,
              nom: nom,
              prenom: prenom,
              tel: tel,
              tel2: tel2,
              email: email,
              adresse: adressePerso,
              adresseFacturation: adresseEcuries,
              ville: ville,
              region: region,
              derniereVisite: derniereVisite,
            );
            Navigator.pop(context, newClient); 
          }
        },
        child: const Icon(Icons.save, color: AppColors.buttonBackgroundColor),
        backgroundColor: Constants.turquoiseDark,
      ),

    );
  }
}
