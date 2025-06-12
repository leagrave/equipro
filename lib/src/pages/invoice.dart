import 'package:equipro/src/pages/facture/listFacture.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({Key? key}) : super(key: key);

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
        child: ListInvoicePage(), 
      ),
    );
  }
}