import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/style/appColor.dart';

class ClientListWidget extends StatelessWidget {
  final List<Client> filteredClients;
  final Function(Client) onClientTap;

  const ClientListWidget({
    Key? key,
    required this.filteredClients,
    required this.onClientTap,
  }) : super(key: key);

  // Fonction pour lancer un appel téléphonique
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return filteredClients.isNotEmpty
        ? ListView.builder(
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              final client = filteredClients[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Color(0xFF323C46), // Gris bleuâtre
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.gradientStartColor, // Bleu-gris profond
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    "${client.nom} ${client.prenom}",
                    style: TextStyle(
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
                        onPressed: () {
                          // Appel du client
                          _makePhoneCall(client.tel);
                        },
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
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  onTap: () => onClientTap(client),
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
