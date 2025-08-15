// import 'package:equipro/src/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:equipro/src/widgets/bar/appBarWidget.dart';
// import 'package:equipro/src/models/invoice.dart';

// class CreateInvoicePage extends StatefulWidget {
//   @override
//   _CreateInvoicePageState createState() => _CreateInvoicePageState();
// }

// class _CreateInvoicePageState extends State<CreateInvoicePage> {
//   final _formKey = GlobalKey<FormState>();

//   int idInvoice = 0;
//   int idClient = 0;
//   int idHorse = 0;
//   bool isSociete = false;
//   String addressFacturation = '';
//   DateTime dateCreation = DateTime.now();
//   DateTime? dateEcheance;
//   String etat = 'En cours';
//   bool paye = false;
//   double montant = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const MyWidgetAppBar(
//         title: 'Créer une facture',
//         logoPath: 'assets/images/image-logo.jpg',
//         backgroundColor: Constants.appBarBackgroundColor,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: Constants.gradientBackground,
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'ID Facture',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onSaved: (value) => idInvoice = int.tryParse(value ?? '0') ?? 0,
//                     validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'ID Client',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onSaved: (value) => idClient = int.tryParse(value ?? '0') ?? 0,
//                     validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'ID Cheval',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onSaved: (value) => idHorse = int.tryParse(value ?? '0') ?? 0,
//                     validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Adresse de facturation',
//                       border: OutlineInputBorder(),
//                     ),
//                     onSaved: (value) => addressFacturation = value ?? '',
//                     validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
//                   ),
//                   SizedBox(height: 16),
//                   SwitchListTile(
//                     title: const Text('Est une société'),
//                     value: isSociete,
//                     onChanged: (value) => setState(() => isSociete = value),
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Montant (€)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onSaved: (value) => montant = double.tryParse(value ?? '0') ?? 0.0,
//                     validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Date d\'échéance (JJ/MM/AAAA)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.datetime,
//                     onSaved: (value) {
//                       try {
//                         if (value != null && value.isNotEmpty) {
//                           dateEcheance = DateTime.parse(value.split('/').reversed.join('-'));
//                         }
//                       } catch (_) {
//                         dateEcheance = null; 
//                       }
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   SwitchListTile(
//                     title: Text('Facture Payée'),
//                     value: paye,
//                     onChanged: (value) => setState(() => paye = value),
//                   ),
//                   SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     value: etat,
//                     decoration: const InputDecoration(
//                       labelText: 'État',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: ['En cours', 'Payée', 'Annulée']
//                         .map((etat) => DropdownMenuItem(
//                               value: etat,
//                               child: Text(etat),
//                             ))
//                         .toList(),
//                     onChanged: (value) => setState(() => etat = value ?? 'En cours'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             _formKey.currentState!.save();
//             final newInvoice = Invoice(
//               idInvoice: idInvoice,
//               idClient: idClient,
//               idHorse: idHorse,
//               etat: etat,
//               paye: paye,
//               montant: montant,
//               isSociete: isSociete,
//               dateCreation: dateCreation,
//               addressFacturation: addressFacturation,
//               dateEcheance: dateEcheance,
//             );
//             Navigator.pop(context, newInvoice); 
//           }
//         },
//         child: const Icon(Icons.save),
//         backgroundColor: Constants.turquoiseDark,
//       ),
//     );
//   }
// }
