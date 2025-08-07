// import 'package:equipro/src/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:equipro/src/models/invoice.dart';

// class InvoiceCardWidget extends StatefulWidget {
//   final Invoice invoice;
//   final Function(Invoice)? onInvoiceUpdated;

//   const InvoiceCardWidget({
//     Key? key,
//     required this.invoice,
//     this.onInvoiceUpdated,
//   }) : super(key: key);

//   @override
//   _InvoiceCardWidgetState createState() => _InvoiceCardWidgetState();
// }

// class _InvoiceCardWidgetState extends State<InvoiceCardWidget> {
//   late Invoice _invoice;
//   bool _isEditing = false;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _invoice = widget.invoice;
//   }

//   void _updateInvoice({DateTime? creationDate, DateTime? dueDate}) {
//     setState(() {
//       _invoice = Invoice(
//         idInvoice: _invoice.idInvoice,
//         idClient: _invoice.idClient,
//         idHorse: _invoice.idHorse,
//         etat: _invoice.etat,
//         montant: _invoice.montant,
//         dateCreation: creationDate ?? _invoice.dateCreation,
//         dateEcheance: dueDate ?? _invoice.dateEcheance,
//         paye: _invoice.paye,
//         isSociete: _invoice.isSociete,
//         addressFacturation: _invoice.addressFacturation,
//       );
//     });

//     if (widget.onInvoiceUpdated != null) {
//       widget.onInvoiceUpdated!(_invoice);
//     }
//   }

//   String formatDate(DateTime? date) {
//     if (date == null) return "Non défini";
//     return DateFormat('dd/MM/yyyy').format(date);
//   }

//   Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onDateSelected) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       onDateSelected(pickedDate);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         color: Colors.white.withOpacity(0.9),
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Date de création et d'échéance
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: _isEditing
//                           ? () {
//                               _selectDate(context, _invoice.dateCreation ?? DateTime.now(), (pickedDate) {
//                                 _updateInvoice(creationDate: pickedDate);
//                               });
//                             }
//                           : null,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           labelText: 'Date de création',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         controller: TextEditingController(text: formatDate(_invoice.dateCreation)),
//                         readOnly: true,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: _isEditing
//                           ? () {
//                               _selectDate(context, _invoice.dateEcheance ?? DateTime.now(), (pickedDate) {
//                                 _updateInvoice(dueDate: pickedDate);
//                               });
//                             }
//                           : null,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           labelText: 'Date d\'échéance',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         controller: TextEditingController(text: formatDate(_invoice.dateEcheance)),
//                         readOnly: true,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Montant
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Montant (€)',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: _invoice.montant.toString()),
//                 readOnly: !_isEditing,
//                 onChanged: (value) {
//                   final double? newAmount = double.tryParse(value);
//                   if (newAmount != null) {
//                     _updateInvoice();
//                   }
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Boutons pour modifier et enregistrer
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isEditing = !_isEditing;
//                       });
//                     },
//                     child: Text(_isEditing ? 'Annuler' : 'Modifier',style: TextStyle(color: Constants.appBarBackgroundColor),),
//                   ),
//                   if (_isEditing)
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           setState(() {
//                             _isEditing = false;
//                           });
//                         }
//                       },
//                       child: const Text('Enregistrer',style: TextStyle(color: Constants.appBarBackgroundColor),),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
