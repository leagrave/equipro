import 'package:flutter/material.dart';
import 'package:equipro/src/models/invoice.dart';

class InvoiceListWidget extends StatelessWidget {
  final List<Invoice> invoices;
  final void Function(Invoice) onInvoiceTap;

  const InvoiceListWidget({
    Key? key,
    required this.invoices,
    required this.onInvoiceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) {
      return const Center(
        child: Text(
          'Aucune facture trouvée.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.separated(
      itemCount: invoices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => onInvoiceTap(invoice),
            title: Text(
              invoice.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Numéro : ${invoice.number}'),
                Text('Montant : ${invoice.totalAmount.toStringAsFixed(2)} €'),
                Text('Statut : ${invoice.status ?? "Non défini"}'),
                if (invoice.issueDate != null)
                  Text('Date : ${invoice.issueDate!.day}/${invoice.issueDate!.month}/${invoice.issueDate!.year}'),
              ],
            ),
            trailing: Icon(
              invoice.isPaid == true ? Icons.check_circle : Icons.hourglass_bottom,
              color: invoice.isPaid == true ? Colors.green : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}