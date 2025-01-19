import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:go_router/go_router.dart';

class ButtonClientListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, 
        ),
        onPressed: () {
          // afficher la fiche du proprio ou la liste des proprio dans l'agenda
          context.go('/');  
        },

        child: const Column(
          mainAxisSize: MainAxisSize.min, 
          children: <Widget>[
            Icon(
              Icons.person, 
              color: Colors.white,
              size: 30, 
            ),
            Text(
              "Mon Propriétaire",
              style: TextStyle(
                color: Colors.white, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
