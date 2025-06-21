// import 'package:flutter/material.dart';
// import 'package:equipro/src/models/horse.dart';
// import 'package:intl/intl.dart';

// class HorseCardWidget extends StatefulWidget {
//   final Horse horse;
//   final Function(Horse)? onHorseUpdated;
//   final bool openWithCreateHorsePage;

//   const HorseCardWidget({
//     Key? key,
//     required this.horse,
//     required this.openWithCreateHorsePage,
//     this.onHorseUpdated,
//   }) : super(key: key);

//   @override
//   _HorseCardWidgetState createState() => _HorseCardWidgetState();
// }

// class _HorseCardWidgetState extends State<HorseCardWidget> {
//   late Horse _horse;
//   bool _isEditing = false;
//   final _formKey = GlobalKey<FormState>();
//   bool openWithCreateHorsePage = false;

//   @override
//   void initState() {
//     super.initState();
//     _horse = widget.horse;

//     if (widget.openWithCreateHorsePage == true) {
//       setState(() {
//          _isEditing = !_isEditing;
//       });
//     }
//   }

//   void _updateHorse({
//     String? name,
//     String? race,
//     int? age,
//     String? color,
//     String? feedingType,
//     String? activityType,
//   }) {
//     setState(() {
//       _horse = Horse(
//         id: _horse.id,
//         idClient: _horse.idClient,
//         name: name ?? _horse.name,
//         ownerId: _horse.ownerId,
//         race: race ?? _horse.race,
//         age: age ?? _horse.age,
//         color: color ?? _horse.color,
//         feedingType: feedingType ?? _horse.feedingType,
//         activityType: activityType ?? _horse.activityType,
//         lastAppointmentDate: _horse.lastAppointmentDate,
//       );
//     });

//     if (widget.onHorseUpdated != null) {
//       widget.onHorseUpdated!(_horse);
//     }
//   }

//   String formatDate(DateTime? date) {
//     if (date == null) return "Pas de rendez-vous";
//     return DateFormat('dd/MM/yyyy').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         color: Colors.white.withOpacity(0.8),
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Dernière visite (divisé en deux TextFields)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Dernière visite',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       controller: TextEditingController(
//                           text: formatDate(_horse.lastAppointmentDate)),
//                       readOnly: !_isEditing,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Prochaine visite',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       controller: TextEditingController(
//                           text: formatDate(_horse.lastAppointmentDate)),
//                       readOnly: !_isEditing,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               // Nom
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Nom',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 controller: TextEditingController(text: _horse.name),
//                 readOnly: !_isEditing,
//                 onChanged: (value) => _updateHorse(name: value),
//               ),
//               const SizedBox(height: 8),

//               // Race
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Race',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 controller: TextEditingController(text: _horse.race),
//                 readOnly: !_isEditing,
//                 onChanged: (value) => _updateHorse(race: value),
//               ),
//               const SizedBox(height: 8),

//               // Âge
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Âge',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//                 controller: TextEditingController(text: _horse.age.toString()),
//                 readOnly: !_isEditing,
//                 onChanged: (value) {
//                   final int? newAge = int.tryParse(value);
//                   if (newAge != null) {
//                     _updateHorse(age: newAge);
//                   }
//                 },
//               ),
//               const SizedBox(height: 8),

//               // Couleur
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Couleur',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 controller: TextEditingController(text: _horse.color),
//                 readOnly: !_isEditing,
//                 onChanged: (value) => _updateHorse(color: value),
//               ),
//               const SizedBox(height: 8),

//               // Type d'alimentation
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Type d\'alimentation',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 controller:
//                     TextEditingController(text: _horse.feedingType),
//                 readOnly: !_isEditing,
//                 onChanged: (value) => _updateHorse(feedingType: value),
//               ),
//               const SizedBox(height: 8),

//               // Type d'activité
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Type d\'activité',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 controller:
//                     TextEditingController(text: _horse.activityType),
//                 readOnly: !_isEditing,
//                 onChanged: (value) => _updateHorse(activityType: value),
//               ),
//               const SizedBox(height: 8),

//               // Afficher les boutons si onHorseUpdated est null
//               if (!widget.openWithCreateHorsePage)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (_isEditing) ...[
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _horse = widget.horse; 
//                             _isEditing = false;
//                           });
//                         },
//                         child: const Text('Annuler'),
//                       ),
//                       const SizedBox(width: 8),
//                     ],
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           if (_isEditing) {
//                             // Valide le formulaire avant d'enregistrer
//                             if (_formKey.currentState?.validate() ?? false) {
//                               if (widget.onHorseUpdated != null) {
//                                 widget.onHorseUpdated!(_horse); 
//                               }
//                             }
//                           }
//                           _isEditing = !_isEditing; 
//                         });
//                       },
//                       child: Text(_isEditing ? 'Enregistrer' : 'Modifier'),
//                     ),
//                   ],
//                 ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
