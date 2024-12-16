import 'package:flutter/material.dart';
import 'package:equipro/router/router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EquiPro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Route par défaut
      onGenerateRoute: AppRouter.generateRoute, // Gestion des routes
    );
  }
}
