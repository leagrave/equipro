// import 'package:flutter/material.dart';
// import 'package:equipro/src/utils/constants.dart';
// import 'package:equipro/src/models/invoice.dart'; 
// import 'package:intl/intl.dart'; 

// class InvoiceListWidget extends StatelessWidget {
//   final List<Invoice> invoices;
//   final Function(Invoice) onInvoiceTap;

//   const InvoiceListWidget({
//     Key? key,
//     required this.invoices,
//     required this.onInvoiceTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Instance de DateFormat pour le formatage des dates
//     final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           if (invoices.isEmpty)
//             const Center(
//               child: Text(
//                 "Aucune facture trouvée",
//                 style: TextStyle(color: Constants.grey, fontSize: 18),
//               ),
//             )
//           else
//             // Liste des factures
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(), 
//               itemCount: invoices.length,
//               itemBuilder: (context, index) {
//                 final invoice = invoices[index];

//                 return Card(
//                   elevation: 4,
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               invoice.status, 
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               "${dateFormatter.format(invoice.dateCreation!)}", 
//                               style: const TextStyle(fontSize: 14, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           invoice.paye
//                               ? "Payée"
//                               : "Non payée", 
//                           style: TextStyle(
//                             color: invoice.paye ? Colors.green : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
//                     onTap: () {
//                       onInvoiceTap(invoice); 
//                     },
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
