import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:intl/intl.dart'; // Package pour le formatage des dates

class HorseListWidget extends StatelessWidget {
  final List<Horse> horses;
  final Function(Horse) onHorseTap;

  const HorseListWidget({
    Key? key,
    required this.horses,
    required this.onHorseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instance de DateFormat pour le format jj/mm/yyyy
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    return ListView.builder(
      itemCount: horses.length,
      itemBuilder: (context, index) {
        final horse = horses[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  horse.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${horse.age} ans",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Text(
              horse.lastAppointmentDate != null
                  ? "Dernière visite : ${dateFormatter.format(horse.lastAppointmentDate!)}"
                  : "Aucune visite",
              style: TextStyle(
                color: horse.lastAppointmentDate == null ? Colors.grey : Colors.black,
              ),
            ),
            onTap: () => onHorseTap(horse),
          ),
        );
      },
    );
  }
}
