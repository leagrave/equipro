import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/router/router.dart';
import 'package:go_router/go_router.dart'; // Assurez-vous que votre routeur est bien importé

class ButtonHorseListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, // Couleur du bouton
        ),
        onPressed: () {
          context.go('/', extra: false);
          // Navigator.pushNamed(
          //   context,
          //   '/agenda',
          //   arguments: false, // Exemple : envoie `false` pour la liste des chevaux
          // );
        },

        child: Text(
          "Chevaux",
          style: TextStyle(
            color: Colors.white, // Couleur du texte
          ),
        ),
      ),
    );
  }
}
