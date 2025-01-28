import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/widgets/list/invoiceListWidget.dart'; 
import 'package:equipro/style/appColor.dart';
import 'package:go_router/go_router.dart';

class ListInvoicePage extends StatefulWidget {
  @override
  _ListInvoicePageState createState() => _ListInvoicePageState();
}

class _ListInvoicePageState extends State<ListInvoicePage> {
  List<Invoice> invoices = [
    Invoice(
      idInvoice: 1,
      idClient: 1,
      idHorse: 1,
      etat: "En attente",
      dateCreation: DateTime(2024, 12, 1),
      paye: false,
      montant: 150.0,
      adresseFacturation: "17 rue du marchand 13110 port de bouc",
      isSociete: false,
    ),
    Invoice(
      idInvoice: 2,
      idClient: 1,
      idHorse: 2,
      etat: "Payée",
      dateCreation: DateTime(2024, 11, 20),
      paye: true,
      montant: 200.0,
      adresseFacturation: "17 rue du marchand 13110 port de bouc",
      isSociete: false,
    ),
    Invoice(
      idInvoice: 3,
      idClient: 1,
      idHorse: 3,
      etat: "En attente",
      dateCreation: DateTime(2024, 12, 5),
      paye: false,
      montant: 120.0,
      adresseFacturation: "17 rue du marchand 13110 port de bouc",
      isSociete: true,
    ),
  ];

  List<Invoice> filteredInvoices = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredInvoices = invoices; 
  }

  void filterInvoices(String query) {
    setState(() {
      searchQuery = query;
      filteredInvoices = invoices.where((invoice) {
        final etatLower = invoice.etat.toLowerCase();
        final dateCreation = invoice.dateCreation != null
            ? invoice.dateCreation!.toString().toLowerCase()
            : '';
        return etatLower.contains(query.toLowerCase()) ||
            dateCreation.contains(query.toLowerCase()) ||
            invoice.montant.toString().contains(query);
      }).toList();
    });
  }

  void navigateToInvoiceDetailsPage(Invoice invoice) async {
    context.push('/managementInvoice', extra: invoice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Barre de Recherche
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: filterInvoices,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF28313E)),
                    hintText: "Rechercher par état, date ou montant",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Liste des factures filtrées
              Expanded(
                child: InvoiceListWidget(
                  invoices: filteredInvoices,
                  onInvoiceTap: (invoice) {
                    navigateToInvoiceDetailsPage(invoice);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/createInvoice");
        },
        backgroundColor: Constants.appBarBackgroundColor, 
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}
