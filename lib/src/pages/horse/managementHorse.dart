import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/widgets/card/horseAdresseCardWidget.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/card/horseCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:equipro/src/widgets/card/listBottumHorseCardWidget.dart';

class ManagementHorsePage extends StatelessWidget {
  final Horse horse;

  const ManagementHorsePage({Key? key, required this.horse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Coordonnées fictives (par défaut).
    final Location defaultLocation = Location(
      latitude: 45.7579211, 
      longitude: 4.7527296, // Paris, France.
    );

    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Gestion cheval',
        logoPath: 'assets/images/image-logo.jpg', // Chemin du logo
        onNotificationTap: () {
          // Action lors du clic sur l'icône de notification
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

                const SizedBox(height: 2),
                HorseCardWidget(horse: horse),

                // Card avec l'adresse
                HorseAddressCardWidget(
                  address: horse.adresse ?? 'Adresse non renseignée',
                  location: defaultLocation,
                  onAddressChanged: (newAddress) {
                    print("Nouvelle adresse : $newAddress");
                  },
                ),

                const SizedBox(height: 2),
                ListbottumHorsecardwidget(),

                const SizedBox(height: 2),
                ClientNotesCardWidget(initialNotes: horse.notes ?? ""),
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
