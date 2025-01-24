import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/bottum/bottumFactureListWidget.dart';
import 'package:equipro/src/widgets/bottum/bottumHoseListWidget.dart';

class ListbottumClientcardwidget extends StatelessWidget {
  final DateTime lastAppointmentDate;
  final DateTime? nextAppointmentDate;
  final int idClient; 

  const ListbottumClientcardwidget({
    Key? key,
    required this.lastAppointmentDate,
    required this.idClient,
    this.nextAppointmentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.8), 
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage des dates sous forme de texte
              Text(
                'Dernier rendez-vous : ${_formatDate(lastAppointmentDate)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 4),
              if (nextAppointmentDate != null)
                Text(
                  'Prochain rendez-vous : ${_formatDate(nextAppointmentDate!)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                )
              else
                Text(
                  'Pas de prochain rendez-vous prévu.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: Colors.grey,
                  ),
                ),
              
              SizedBox(height: 2),

 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonHorseListWidget(idClient: idClient), 
                  ButtonFactureListWidget(), 
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
