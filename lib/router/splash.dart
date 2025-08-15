import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  // Instance du stockage sécurisé
  final storage = const FlutterSecureStorage();

  Future<void> checkLogin(BuildContext context) async {
    // Lecture sécurisée des données
    final token = await storage.read(key: 'authToken');
    final userString = await storage.read(key: 'userData');

    await Future.delayed(const Duration(milliseconds: 500));

    if (token != null && userString != null) {
      final user = jsonDecode(userString);
      final isProfessional = user['professional'] == true;

      if (context.mounted) {
        if (isProfessional) {
          context.go('/', extra: {
            'initialPageIndex': 2,
          });
        } else {
          context.go('/homeClient', extra: {
            'initialPageIndex': 2,
          });
        }
      }
    } else {
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
