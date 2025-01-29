import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/facture/invoiceCardWidget.dart';  

class ManagementInvoicePage extends StatelessWidget {
  final Invoice invoice;  

  const ManagementInvoicePage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Gestion Facture',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
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
