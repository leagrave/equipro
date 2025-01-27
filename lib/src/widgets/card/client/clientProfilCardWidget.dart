import 'package:flutter/material.dart';


class UserCard extends StatelessWidget {
  final String profileImageUrl;
  final String firstName;
  final String lastName;
  final bool isProfessional;
  final bool isVerified;
  final VoidCallback onEditProfile;
  final VoidCallback onUserTap;  

  const UserCard({
    Key? key,
    required this.profileImageUrl,
    required this.firstName,
    required this.lastName,
    required this.isProfessional,
    required this.isVerified,
    required this.onEditProfile,
    required this.onUserTap,  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  
      onTap: onUserTap,  
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image de profil
              ClipRRect(
                borderRadius: BorderRadius.circular(8), 
                child: Image.asset(
                  profileImageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Informations de l'utilisateur
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et prénom
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Catégorie (Professionnel ou Particulier) et statut de vérification
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isVerified ? Colors.yellow[100] : Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isVerified ? 'Professionnel' : 'Non Particulier',
                            style: TextStyle(
                              fontSize: 12,
                              color: isVerified ? Colors.grey : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isVerified ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isVerified ? 'Vérifié' : 'Non vérifié',
                            style: TextStyle(
                              fontSize: 12,
                              color: isVerified ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flèche de redirection
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: onEditProfile,  // Conserve la logique d'édition
              ),
            ],
          ),
        ),
      ),
    );
  }
}
