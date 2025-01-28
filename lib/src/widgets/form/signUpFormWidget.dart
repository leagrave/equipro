import 'package:flutter/material.dart';

class SignUpFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Champ pour le nom
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person, color: Colors.white),
              hintText: 'Nom',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12), 
          
          // Champ pour le prénom
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person, color: Colors.white),
              hintText: 'Prénom',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          
          // Champ d'e-mail
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email, color: Colors.white),
              hintText: 'Adresse e-mail',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          
          // Champ de mot de passe
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock, color: Colors.white),
              hintText: 'Mot de passe',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          
          // Champ de confirmation de mot de passe
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock, color: Colors.white),
              hintText: 'Confirmer le mot de passe',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
            ),
            style: const TextStyle(color: Colors.white),
          ),
          
          // Conseils sur la sécurité du mot de passe
          const Text(
            "8 caractères, une majuscule, un minuscule, un chiffre, et un caractère spécial",
            style: TextStyle(
              color: Colors.grey, 
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
