import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/router/router.dart'; // Assurez-vous que votre routeur est bien importé

class ButtonClientListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, // Couleur du bouton
        ),
        onPressed: () {
          // Navigation vers la page des chevaux (ListHorsePage) avec le paramètre
          Navigator.pushNamed(
            context,
            '/agenda',
            arguments: true, // Exemple : envoie `false` pour la liste des chevaux
          );
        },

        child: Text(
          "Propriètaire",
          style: TextStyle(
            color: Colors.white, // Couleur du texte
          ),
        ),
      ),
    );
  }
}
