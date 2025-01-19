import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/invoiceCardWidget.dart';  // Widget pour afficher les factures

class ManagementInvoicePage extends StatelessWidget {
  final Invoice invoice;  // La facture seule est maintenant transmise

  const ManagementInvoicePage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Gestion Facture',
        logoPath: Constants.logo,
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(  
            child: Column(
              children: [
                // Affichage des informations de la facture
                const SizedBox(height: 20),
                InvoiceCardWidget( 
                  invoice: invoice,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
