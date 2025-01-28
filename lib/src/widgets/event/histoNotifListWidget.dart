import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';

class HistoriqueNotificationListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'avatar': null,
      'name': 'John Doe',
      'isSystem': false,
      'messageType': 'message',
      'time': '10:30 AM',
      'message': 'Ceci est un message classique de test.',
    },
    {
      'avatar': null,
      'name': 'Système',
      'isSystem': true,
      'messageType': 'message_system',
      'time': '9:15 AM',
      'message': 'Système : mise à jour disponible.',
    },
    {
      'avatar': null,
      'name': 'Jane Smith',
      'isSystem': false,
      'messageType': 'demande_changement',
      'time': '8:45 AM',
      'message': 'Demande de changement de rendez-vous pour demain.',
    },
    {
      'avatar': null,
      'name': 'Alex Turner',
      'isSystem': false,
      'messageType': 'annulation_rdv',
      'time': '7:30 AM',
      'message': 'Votre rendez-vous a été annulé.',
    },
    {
      'avatar': null,
      'name': 'Alex Turner',
      'isSystem': false,
      'messageType': 'annulation_rdv',
      'time': '7:30 AM',
      'message': 'Votre rendez-vous a été annulé.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final messageType = notification['messageType'];
        final name = notification['name'];
        final time = notification['time'];
        final isSystem = notification['isSystem'];
        final avatar = notification['avatar'];
        final message = notification['message'];

        Color messageColor;
        String messageText;
        BoxDecoration messageDecoration;

        // Définir la couleur du message et la décoration en fonction du type
        switch (messageType) {
          case 'message':
            messageColor = Constants.white;
            messageText = 'Message';
            messageDecoration = BoxDecoration(
              color: Constants.secondaryYellow.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            );
            break;
          case 'demande_changement':
            messageColor = Constants.white;
            messageText = 'Changement rendez-vous';
            messageDecoration = BoxDecoration(
              color: Constants.secondaryOrange2.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            );
            break;
          case 'annulation_rdv':
            messageColor = Constants.white;
            messageText = 'Annulation rendez-vous';
            messageDecoration = BoxDecoration(
              color: Constants.secondaryRed.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            );
            break;
          case 'message_system':
            messageColor = Constants.white;
            messageText = 'Message système';
            messageDecoration = BoxDecoration(
              color: Constants.gradientEndColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            );
            break;
          default:
            messageColor = Constants.white;
            messageText = 'Notification';
            messageDecoration = BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            );
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1), 
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: isSystem
                  ? const AssetImage(Constants.logo)
                  : (avatar != null ? NetworkImage(avatar) : const AssetImage(Constants.avatar)),
              radius: 30,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ajout de la BoxDecoration au texte du message
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: messageDecoration,
                  child: Text(
                    messageText,
                    style: TextStyle(
                      color: messageColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Ajout du texte du message sous la partie message
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message, // Texte du message
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
