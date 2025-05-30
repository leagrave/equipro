import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  Future<void> checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userString = prefs.getString('user');

    await Future.delayed(const Duration(milliseconds: 500)); // effet visuel

    if (token != null && userString != null) {
      final user = jsonDecode(userString);
      final idUser = user['idUser'];
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
    checkLogin(context); // Appel dès que la page est rendue

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
