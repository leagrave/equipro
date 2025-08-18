import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bottum/bottumHistoVisitListWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/bottum/bottumFactureListWidget.dart';
import 'package:equipro/src/widgets/bottum/bottumHoseListWidget.dart';
import 'package:intl/intl.dart'; 

class ListbottumClientcardwidget extends StatelessWidget {
  final DateTime? lastAppointmentDate;
  final DateTime? nextAppointmentDate;
  final String idUserPro;
  final String idUserCustomer;

  const ListbottumClientcardwidget({
    Key? key,
    this.lastAppointmentDate,
    required this.idUserPro,
    required this.idUserCustomer,
    this.nextAppointmentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dernier rendez-vous : ${_formatDate(lastAppointmentDate)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Constants.white,
                ),
              ),
              const SizedBox(height: 8),
              if (nextAppointmentDate != null)
                Text(
                  'Prochain rendez-vous : ${_formatDate(nextAppointmentDate)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Constants.white,
                  ),
                )
              else
                const Text(
                  'Pas de prochain rendez-vous prévu.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonHorseListWidget(userCustomID: idUserCustomer, proID: idUserPro,),
                  ButtonHistoVisitListWidget(idUser: idUserCustomer, proID: idUserPro),
                  ButtonFactureListWidget(idUser: idUserCustomer,proID: idUserPro, userCustomID: idUserCustomer),
                ],
              ),
            ],
          ),
        ),
      );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Non défini';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
