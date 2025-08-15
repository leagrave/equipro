import 'dart:convert';

import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/horizontalScrollWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/event/evenementsListWidget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyHomePage extends StatelessWidget {
  // Instance de storage sécurisé
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> _getUserInfo() async {
    final userDataStr = await storage.read(key: 'userData');
    if (userDataStr == null) return null;
    final userData = jsonDecode(userDataStr);
    return userData;
  }

  Future<String?> _getProID() async {
    return await storage.read(key: 'pro_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Constants.paddingMedium),
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Bonjour, utilisateur');
                      }
                      final user = snapshot.data!;
                      final firstName = user['first_name'] ?? '';
                      final lastName = user['last_name'] ?? '';
                      return Text(
                        'Bonjour $firstName $lastName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );

                    },
                  ),

                  //const SizedBox(height: Constants.paddingMedium),

                  MyWidgetAppointments(),

                  const SizedBox(height: Constants.paddingMedium),

                  FutureBuilder<String?>(
                    future: _getProID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Erreur : pro_id non trouvé');
                      }
                      final proID = snapshot.data!;
                      return ElevatedButton.icon(
                        onPressed: () {
                          context.push('/createIntervention', extra: {
                            'proId': proID,
                          });
                        },
                        icon: const Icon(Icons.add, color: Constants.appBarBackgroundColor),
                        label: const Text('Nouvelle intervention'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.white,
                          foregroundColor: Constants.appBarBackgroundColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
