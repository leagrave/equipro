import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/facture/invoiceListWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/widgets/list/invoiceListWidget.dart'; 
import 'package:go_router/go_router.dart';
import 'package:equipro/src/services/apiService.dart'; 
import 'dart:convert';

class ListInvoicePage extends StatefulWidget {
  final String proID;
  final String? customer_id;
  final String? userCustomerID;

  const ListInvoicePage({
    Key? key,
    required this.proID,
    this.customer_id,
    this.userCustomerID,
  }) : super(key: key);

  @override
  _ListInvoicePageState createState() => _ListInvoicePageState();
}

class _ListInvoicePageState extends State<ListInvoicePage> {
  List<Invoice> invoices = [];
  List<Invoice> filteredInvoices = [];
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Utilise le bon endpoint pour récupérer les factures d’un utilisateur
      final response = await ApiService.getWithAuth(
        '/factures/user/${widget.userCustomerID}'
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        invoices = data.map((json) => Invoice.fromJson(json)).toList();
        filteredInvoices = invoices;
      } else {
        invoices = [];
        filteredInvoices = [];
      }
    } catch (e) {
      invoices = [];
      filteredInvoices = [];
    }
    setState(() {
      isLoading = false;
    });
  }

  void filterInvoices(String query) {
    setState(() {
      searchQuery = query;
      filteredInvoices = invoices.where((invoice) {
        final numberLower = invoice.number.toLowerCase();
        final titleLower = invoice.title.toLowerCase();
        final statusLower = (invoice.status ?? '').toLowerCase();
        final totalAmountStr = invoice.totalAmount.toString();
        final issueDateStr = invoice.issueDate != null
            ? invoice.issueDate!.toString().toLowerCase()
            : '';
        return numberLower.contains(query.toLowerCase()) ||
            titleLower.contains(query.toLowerCase()) ||
            statusLower.contains(query.toLowerCase()) ||
            totalAmountStr.contains(query) ||
            issueDateStr.contains(query.toLowerCase());
      }).toList();
    });
  }

  void navigateToInvoiceDetailsPage(Invoice invoice) async {
    //context.push('/managementInvoice', extra: invoice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Mes Factures',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                    hintText: "Rechercher par numéro, titre, statut, montant ou date",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Liste des factures filtrées ou loader
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : InvoiceListWidget(
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
          context.push('/createInvoice', extra: {
            'proID': widget.proID,
          });
        },
        backgroundColor: Constants.turquoiseDark, 
        child: const Icon(Icons.add, color: Constants.white),
      ),
    );
  }
}