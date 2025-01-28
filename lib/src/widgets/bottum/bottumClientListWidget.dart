import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:go_router/go_router.dart';

class ButtonClientListWidget extends StatelessWidget {
  final int idClient;

  const ButtonClientListWidget({Key? key, required this.idClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, 
        ),
        // onPressed: () {
        //   // afficher la fiche du proprio ou la liste des proprio dans l'agenda
        //   context.push('/listClient', extra: {'idClient': idClient});
        // },
        onPressed: () {
          context.push('/', extra: {'initialPageIndex': 1, 'idClient': idClient}); // Index 1 pour MyAgendaPage
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
