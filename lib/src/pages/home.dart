import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/home/evenementsListWidget.dart';
import 'package:equipro/style/appColor.dart';

/// Widget pour la barre de navigation
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'EquiPro',
        logoPath: 'assets/images/image-logo.jpg', // Le chemin du logo
        onNotificationTap: () {
          // Action lors du clic sur l'icône de notification
          print('Notifications');
        },
        backgroundColor: AppColors.appBarBackgroundColor, // Utilisation de la couleur pour l'AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStartColor, AppColors.gradientEndColor], // Utilisation des couleurs pour le gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Section pour afficher les prochains rendez-vous
            MyWidgetAppointments(),

            // Boutons ou autres widgets peuvent suivre ici
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Naviguer vers d'autres pages ou modules
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackgroundColor, // Couleur de fond du bouton
                    foregroundColor: AppColors.buttonTextColor, // Couleur du texte du bouton
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Aller à une section'),
                ),
              ),
            ),
          ],
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