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
          icon: Icon(Icons.calendar_today),
          label: 'Rendez-vous',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
      onTap: onTap, // Appelle la fonction passée en paramètre
    );
  }
}
