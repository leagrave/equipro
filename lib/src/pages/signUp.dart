import 'package:equipro/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/form/signUpFormWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MySignupPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan en dégradé
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1BD5DB), Color(0xFF28313E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Contenu principal
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo ou image en haut
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/images/image-logo.jpg'), 
                    ),
                    const SizedBox(height: 20),
                    // Texte d'en-tête
                    const AutoSizeText(
                      'Bienvenue sur EquiPro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const AutoSizeText(
                      'Créez votre compte pour commencer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),

                    SignUpFormWidget(),

                    const SizedBox(height: 30),
                    // Bouton de création de compte
                    ElevatedButton(
                      onPressed: () {
                        // Ajouter la logique de création de compte ici
                        print('Création de compte...');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF28313E),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const AutoSizeText(
                        'Créer un compte',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Lien déjà inscrit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AutoSizeText(
                          "Déjà un compte ? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Ajouter la logique pour rediriger vers la page de connexion
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyLoginPage(), // Page d'inscription
                              ),
                            );
                          },
                          child: const AutoSizeText(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
