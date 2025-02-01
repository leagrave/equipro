import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      'idClient': 1,
      'avatar': null,
      'nom': 'John',
      'prenom': 'Doe',
      'isRead': true,
      'isSent': true,
      'dateReception': '27 Jan 2025',
    },
    {
      'idClient': 2,
      'avatar': null,
      'nom': 'Jane',
      'prenom': 'Smith',
      'isRead': false,
      'isSent': false,
      'dateReception': '26 Jan 2025',
    },
    {
      'idClient': 3,
      'avatar': null,
      'nom': 'Alex',
      'prenom': 'Turner',
      'isRead': true,
      'isSent': false,
      'dateReception': '25 Jan 2025',
    },
    {
      'idClient': 4,
      'avatar': null,
      'nom': 'Emily',
      'prenom': 'Clark',
      'isRead': false,
      'isSent': true,
      'dateReception': '24 Jan 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final idClient = message['idClient'];
        final avatar = message['avatar'];
        final nom = message['nom'];
        final prenom = message['prenom'];
        final isRead = message['isRead'];
        final isSent = message['isSent'];
        final dateReception = message['dateReception'];

        return GestureDetector(
           onTap: () {
              context.push('/chat', extra: {'idClient': idClient} );
            },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar à gauche
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: avatar != null
                      ? NetworkImage(avatar)
                      : const AssetImage('assets/images/default_avatar.jpg')
                          as ImageProvider,
                  radius: 25,
                ),
                const SizedBox(width: 10),
                // Nom, prénom et état du message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom et prénom
                      Text(
                        '$prenom $nom',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // État du message (lu/non lu, envoyé/non envoyé)
                      Row(
                        children: [
                          Icon(
                            isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                            color: isRead ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRead ? 'Lu' : 'Non lu',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            isSent ? Icons.send : Icons.error_outline,
                            color: isSent ? Colors.blue : Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isSent ? 'Envoyé' : 'Non envoyé',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Date de réception
                Text(
                  dateReception,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
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
