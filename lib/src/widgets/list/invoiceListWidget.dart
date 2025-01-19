import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/models/invoice.dart'; // Importer le modèle Invoice
import 'package:intl/intl.dart'; // Pour le formatage des dates
import 'package:go_router/go_router.dart';

class InvoiceListWidget extends StatelessWidget {
  final List<Invoice> invoices;
  final Function(Invoice) onInvoiceTap;

  const InvoiceListWidget({
    Key? key,
    required this.invoices,
    required this.onInvoiceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instance de DateFormat pour le formatage des dates
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      child: Column(
        children: [
          if (invoices.isEmpty)
            Center(
              child: Text(
                "Aucune facture trouvée",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          else
            // Liste des factures
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), 
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              invoice.etat, 
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${dateFormatter.format(invoice.dateCreation!)}", 
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          invoice.paye
                              ? "Payée"
                              : "Non payée", 
                          style: TextStyle(
                            color: invoice.paye ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    onTap: () {
                      onInvoiceTap(invoice); 
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
