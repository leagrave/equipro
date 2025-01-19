import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/src/widgets/card/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/listBottumClientCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';

class ManagementClientPage extends StatelessWidget {
  final Client client;

  // Constructor qui prend un client
  const ManagementClientPage({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sélectionnez la première adresse de la liste pour l'affichage.
    final String selectedAddress = (client.adresses != null && client.adresses!.isNotEmpty)
        ? client.adresses!.first
        : 'Adresse non disponible';

    // Coordonnées fictives (par défaut).
    final Location defaultLocation = Location(latitude: 45.7579211, longitude: 4.7527296); // Paris, France.

    // TODO: Remplacez `defaultLocation` par une vraie localisation après géocodage.
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Gestion client',
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
          child: SingleChildScrollView(  // Envelopper le contenu dans un SingleChildScrollView
            child: Column(
              children: [
                ClientCardWidget(
                  idClient: client.idClient,
                  email: client.email,
                  tel: client.tel,
                  initialName: client.nom,
                  initialSurname: client.prenom,
                  isSociete: client.isSociete ?? false,
                ),
                const SizedBox(height: 2),
                AddressCardWidget(
                  addresses: client.adresses,
                  location: defaultLocation
                ),
                const SizedBox(height: 2),
                ListbottumClientcardwidget(
                  lastAppointmentDate: client.derniereVisite ?? DateTime.now(),
                  nextAppointmentDate: client.prochaineIntervention ?? DateTime.now(),
                ),
                const SizedBox(height: 2),
                ClientNotesCardWidget(initialNotes: client.notes ?? ""),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyWidgetBottomNavBar(
        onTap: (index) {
          // Navigation selon l'index sélectionné
        },
      ),
    );
  }
}
