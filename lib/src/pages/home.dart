import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/home/evenementsListWidget.dart';
import 'package:equipro/style/appColor.dart';

/// Widget pour la barre de navigation
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise], 
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
    );
  }
}