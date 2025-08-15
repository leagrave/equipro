import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/form/signUpFormWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';

class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key});

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  bool _triggerValidation = false;

  void _onCreateAccountPressed() {
    setState(() {
      _triggerValidation = !_triggerValidation;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: Constants.gradientLoginBackground,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(Constants.logo),
                    ),
                    const SizedBox(height: 20),
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

                    // Enfant qui écoute la validation
                    SignUpFormWidget(
                      triggerValidation: _triggerValidation,
                      enSaisie: true,
                      openWithSignUp: true,
                    ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _onCreateAccountPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF28313E),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AutoSizeText(
                          "Déjà un compte ? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
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
                    const SizedBox(height: 20),
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
