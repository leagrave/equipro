import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/router/router.dart'; // Assurez-vous que votre routeur est bien importé

class ButtonFactureListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, // Couleur du bouton
        ),
        onPressed: () {
          // Navigation vers la page des chevaux (ListHorsePage) // ajouter arguments: horse.id
          Navigator.pushNamed(context, '/facture');
        },
        child: Text(
          "Factures",
          style: TextStyle(
            color: Colors.white, // Couleur du texte
          ),
        ),
        // Icon(
        //   Icons.picture_as_pdf_outlined, 
        //   color: Colors.white, // Couleur de l'icône
        // ),
      ),
    );
  }
}