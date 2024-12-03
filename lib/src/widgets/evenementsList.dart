import 'package:flutter/material.dart';


// Widget pour afficher les prochains rendez-vous
class MyWidgetAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prochains Rendez-vous',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Liste des rendez-vous à venir
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        'Rendez-vous $index',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            // Ajouter un bouton pour voir plus
            ElevatedButton(
              onPressed: () {
                // Logique pour voir tous les rendez-vous
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF28313E),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Voir tous les rendez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}