import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart'; // Assurez-vous que ce chemin est correct
import 'package:equipro/src/widgets/bottum/bottumFactureListWidget.dart';
import 'package:equipro/src/widgets/bottum/bottumClientListWidget.dart';

class ListbottumHorsecardwidget extends StatelessWidget {


  const ListbottumHorsecardwidget({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.8), // Fond transparent
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Coins arrondis
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          

              // Les boutons côte à côte
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonClientListWidget(), // Premier bouton
                  ButtonFactureListWidget(), // Deuxième bouton
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
