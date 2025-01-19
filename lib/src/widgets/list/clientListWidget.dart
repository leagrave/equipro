import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/list/horseListWidget.dart';

class ClientListWidget extends StatelessWidget {
  final List<Client> filteredClients;
  final Function(Client) onClientTap;
  final List<Horse> horses;

  const ClientListWidget({
    Key? key,
    required this.filteredClients,
    required this.onClientTap,
    required this.horses,
  }) : super(key: key);

  // Fonction pour lancer un appel téléphonique
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Impossible d\'ouvrir $phoneNumber';
    }
  }

  // Fonction pour naviguer vers la page de gestion des chevaux
  void navigateToManagementHorsePage(BuildContext context, Horse horse) async {
    await Navigator.pushNamed(
      context,
      '/managementHorse',
      arguments: horse,
    );
  }

  @override
  Widget build(BuildContext context) {
    return filteredClients.isNotEmpty
        ? ListView.builder(
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              final client = filteredClients[index];
              final clientHorses = horses.where((horse) => horse.idClient == client.idClient).toList();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFF323C46), // Gris bleuâtre
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.gradientStartColor, // Bleu-gris profond
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        "${client.nom} ${client.prenom}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        client.ville ?? 'Ville non spécifiée',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Bouton d'appel
                          IconButton(
                            icon: const Icon(Icons.call, color: Colors.green),
                            onPressed: () => _makePhoneCall(client.tel),
                          ),
                          // Bouton de message
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue),
                            onPressed: () {
                              // Logique pour envoyer un message au client
                              print('Message à ${client.nom} ${client.prenom}');
                            },
                          ),
                          // Flèche pour la navigation
                          const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                      onTap: () => onClientTap(client),
                    ),
                    // Liste des chevaux associés
                    if (clientHorses.isNotEmpty)
                      HorseListWidget(
                        horses: clientHorses,
                        onHorseTap: (horse) => navigateToManagementHorsePage(context, horse),
                        isFromListHorsePage: false, 
                      ),
                      
                  ],
                ),
              );
            },
          )
        : Center(
            child: Text(
              "Aucun client trouvé",
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}
