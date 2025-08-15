import 'package:equipro/src/pages/facture/userFilePage.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';

class InvoicePage extends StatelessWidget {
  final String? userId;


  const InvoicePage({Key? key, this.userId}) : super(key: key);

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
        // a gérer si client ou si pro
        //child: ListInvoicePage(), 
        child: UserFilesPage(userId: userId ?? ''), 
      ),
    );
  }
}