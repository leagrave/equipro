import 'package:flutter/material.dart';

// Page des factures sous forme de PDF
class ListfacturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dernières Factures'),
      ),
      body: Center(
        child: Text('Affichage des factures sous forme de PDF ici'),
      ),
    );
  }
}