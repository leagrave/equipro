import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyWidgetAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Semantics(
        container: true,
        label: 'Liste des prochains rendez-vous',
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

              Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Semantics(
                            label: 'Rendez-vous numéro $index',
                            child: Text(
                              'Rendez-vous $index',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Tooltip(
                              message: 'Appeler le client',
                              child: IconButton(
                                icon: const Icon(Icons.phone, color: Constants.secondaryGreen, size: 24),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 5),
                            Tooltip(
                              message: 'Envoyer un message',
                              child: IconButton(
                                icon: const Icon(Icons.message, color: Constants.secondaryBleu, size: 24),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 5),
                            Tooltip(
                              message: 'Voir l’emplacement',
                              child: IconButton(
                                icon: const Icon(Icons.location_on, color: Color.fromARGB(197, 234, 36, 36), size: 24),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),

              Center(
                child: Tooltip(
                  message: 'Voir tous les rendez-vous',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
