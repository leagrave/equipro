import 'package:equipro/src/widgets/appBar.dart';
import 'package:equipro/src/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/evenementsList.dart';

// Widget pour la barre de navigation
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF28313E),Color(0xFF1BD5DB)],
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
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF28313E),
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


