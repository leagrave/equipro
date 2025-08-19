import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/services/apiService.dart';

class InvoiceListWidget extends StatelessWidget {
  final List<Invoice> invoices;
  final void Function(Invoice) onInvoiceTap;
  final String userId;
  final String? token;

  const InvoiceListWidget({
    Key? key,
    required this.invoices,
    required this.onInvoiceTap,
    required this.userId,
    this.token,
  }) : super(key: key);

  Future<void> _downloadFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<String?> _getPdfUrlForInvoice(String invoiceId) async {
    final response = await ApiService.getWithAuth('/files/user/$userId');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        final file = data.firstWhere(
          (f) => f['invoiceId'].toString() == invoiceId,
          orElse: () => null,
        );
        if (file != null) return file['signedUrl'];
      }
    }
    return null;
  }

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
            title: Text(invoice.title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.blue),
                  tooltip: 'Télécharger PDF',
                  onPressed: () async {
                    final pdfUrl = await _getPdfUrlForInvoice(invoice.id.toString());
                    if (pdfUrl != null) await _downloadFile(pdfUrl);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  tooltip: 'Visualiser PDF',
                  onPressed: () async {
                    final pdfUrl = await _getPdfUrlForInvoice(invoice.id.toString());
                    if (pdfUrl != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: const Text('Visualiser PDF')),
                            body: SfPdfViewer.network(pdfUrl),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Icon(
                  invoice.isPaid == true ? Icons.check_circle : Icons.hourglass_bottom,
                  color: invoice.isPaid == true ? Colors.green : Colors.orange,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
