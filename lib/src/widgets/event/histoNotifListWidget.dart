import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HistoriqueNotificationListWidget extends StatefulWidget {
  @override
  _HistoriqueNotificationListWidgetState createState() => _HistoriqueNotificationListWidgetState();
}

class _HistoriqueNotificationListWidgetState extends State<HistoriqueNotificationListWidget> {
  List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'avatar': null,
      'name': 'John Doe',
      'isSystem': false,
      'messageType': 'message',
      'time': '10:30 AM',
      'message': 'Ceci est un message classique de test.',
    },
    {
      'id': 2,
      'avatar': null,
      'name': 'Système',
      'isSystem': true,
      'messageType': 'message_system',
      'time': '9:15 AM',
      'message': 'Système : mise à jour disponible.',
    },
    {
      'id': 3,
      'avatar': null,
      'name': 'Jane Smith',
      'isSystem': false,
      'messageType': 'demande_changement',
      'time': '8:45 AM',
      'message': 'Demande de changement de rendez-vous pour demain.',
    },
    {
      'id': 4,
      'avatar': null,
      'name': 'Alex Turner',
      'isSystem': false,
      'messageType': 'annulation_rdv',
      'time': '7:30 AM',
      'message': 'Votre rendez-vous a été annulé.',
    },
  ];

  void _deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((notif) => notif['id'] == id);
    });
  }

  // void _openMessage(Map<String, dynamic> notification) {
  //   // Simule l'ouverture du message dans la messagerie
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Ouverture du message : ${notification['message']}"),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        Color messageColor;
        String messageText;
        BoxDecoration messageDecoration;

        switch (notification['messageType']) {
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
            messageText = 'Changement';
            messageDecoration = BoxDecoration(
              color: Constants.secondaryOrange2.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            );
            break;
          case 'annulation_rdv':
            messageColor = Constants.white;
            messageText = 'Annulation';
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

        return Dismissible(
          key: Key(notification['id'].toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deleteNotification(notification['id']);
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: GestureDetector(
             onTap: () {
              context.push('/chat', extra: {'idClient': notification['id']} );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: notification['isSystem']
                      ? const AssetImage(Constants.logo)
                      : (notification['avatar'] != null
                          ? NetworkImage(notification['avatar'])
                          : const AssetImage(Constants.avatar)),
                  radius: 30,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      notification['time'],
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
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        notification['message'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
