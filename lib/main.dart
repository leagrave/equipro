import 'package:flutter/material.dart';
import 'package:equipro/src/pages/login.dart';


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
      // Définit directement MyLoginPage comme la page principale
      home: MyLoginPage(),
    );
  }
}
