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

    await Future.delayed(const Duration(milliseconds: 500)); // pour l’effet visuel

    if (token != null && userString != null) {
      final user = jsonDecode(userString);
      final idUser = user['idUser'];

      if (context.mounted) {
        context.go('/', extra: {
          'token': token,
          'idClient': idUser,
        });
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
