import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';

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

            // Liste des rendez-vous à venir avec icônes à droite
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nom du rendez-vous
                      Expanded(
                        child: Text(
                          'Rendez-vous $index',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: Constants.secondaryGreen, size: 24),
                            onPressed: () {

                            },
                          ),
                          const SizedBox(width: 5), 

                          IconButton(
                            icon: const Icon(Icons.message, color: Constants.secondaryBleu, size: 24),
                            onPressed: () {

                            },
                          ),
                          const SizedBox(width: 5), 

                          IconButton(
                            icon: const Icon(Icons.location_on, color: Color.fromARGB(197, 234, 36, 36), size: 24),
                            onPressed: () {
  
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
            //const SizedBox(height: 10),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.push('/', extra: {'initialPageIndex': 3});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.white,
                  foregroundColor: Constants.appBarBackgroundColor, 
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Voir tous les rendez-vous',
                  style: TextStyle(color: Constants.appBarBackgroundColor), 
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
