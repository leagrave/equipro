import 'package:equipro/style/appColor.dart';
import 'package:flutter/material.dart';

class MyWidgetBottomNavBar extends StatelessWidget {
  final Function(int) onTap;

  const MyWidgetBottomNavBar({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_agenda_outlined), 
          label: 'Répertoire',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Rendez-vous',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
      onTap: (index) {
        onTap(index); // Appelle la fonction passée en paramètre

        // Gère la navigation en fonction de l'index sélectionné
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');  // Accueil
            break;
          case 1:
            Navigator.pushNamed(context, '/agenda');  // Répertoire
            break;
          case 2:
            Navigator.pushNamed(context, '/calendar');  // Rendez-vous
            break;
          case 3:
            Navigator.pushNamed(context, '/settings');  // Paramètres
            break;
          default:
            break;
        }
      },
        selectedItemColor: AppColors.gradientEndColor, // Couleur de l'icône sélectionnée
        unselectedItemColor: AppColors.gradientStartColor, // Couleur des icônes non sélectionnées
    );
  }
}
