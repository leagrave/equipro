import 'package:flutter/material.dart';

// Page des chevaux
class ListHorsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Chevaux'),
      ),
      body: Center(
        child: Text('Affichage de la liste des chevaux ici'),
      ),
    );
  }
}
