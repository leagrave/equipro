import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise], // Utilisation des couleurs pour le gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center( // Placez Center ici, à l'intérieur du Container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bouton de déconnexion
              ElevatedButton(
                onPressed: () {
                  context.go('/login'); // Redirection vers la page de connexion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.secondaryRed, 
                  foregroundColor: Constants.white, 
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Déconnexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
