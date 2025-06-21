import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:intl/intl.dart'; 
import 'package:equipro/src/models/customer.dart'; 

class HorseListWidget extends StatefulWidget {
  final List<Horse> horses;
  final Function(Horse) onHorseTap;
  final bool isFromListHorsePage;

  const HorseListWidget({
    Key? key,
    required this.horses,
    required this.onHorseTap,
    this.isFromListHorsePage = false,
  }) : super(key: key);

  @override
  _HorseListWidgetState createState() => _HorseListWidgetState();
}

class _HorseListWidgetState extends State<HorseListWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFromListHorsePage) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    final int displayLimit = 3;
    final List<Horse> displayedHorses =
        _isExpanded ? widget.horses : widget.horses.take(displayLimit).toList();

    return Column(
      children: [
        if (widget.horses.isEmpty)
          const Center(
            child: Text(
              "Aucun cheval trouvé",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedHorses.length,
            itemBuilder: (context, index) {
              final horse = displayedHorses[index];
              return ListTile(
                title: Text(horse.name),
                subtitle: Text(horse.lastVisitDate != null
                    ? "Dernière visite : ${dateFormatter.format(horse.lastVisitDate!)}"
                    : "Aucune visite"),
                onTap: () => widget.onHorseTap(horse),
              );
            },
          ),
        if (!widget.isFromListHorsePage && widget.horses.length > displayLimit)
          TextButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(_isExpanded ? "Réduire" : "Voir plus"),
          ),
      ],
    );
  }
}


//   @override
//   void initState() {
//     super.initState();
//     // Si c'est ouvert depuis ListHorsePage, on étend la liste automatiquement
//     if (widget.isFromListHorsePage) {
//       _isExpanded = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Instance de DateFormat pour le format jj/mm/yyyy
//     final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

//     // Limite d'affichage des chevaux dans l'état réduit
//     final int displayLimit = 3;
//     final List<Horse> displayedHorses =
//         _isExpanded ? widget.horses : widget.horses.take(displayLimit).toList();

//     // Récupération de l'idClient depuis le premier cheval (tous les chevaux doivent appartenir au même client)
//     final int? clientId = widget.horses.isNotEmpty ? widget.horses.first.idClient : null;

//     return SingleChildScrollView( 
//       child: Column(
//         children: [
//           // Si la liste des chevaux est vide, afficher "Aucun cheval trouvé"
//           if (widget.horses.isEmpty)
//             const Center(
//               child: Text(
//                 "Aucun cheval trouvé",
//                 style: TextStyle(color: Colors.grey, fontSize: 18),
//               ),
//             )
//           else
//             // Liste des chevaux (visible uniquement si _isExpanded est vrai)
//             if (_isExpanded)
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: widget.isFromListHorsePage 
//                   ? const AlwaysScrollableScrollPhysics()
//                   : const NeverScrollableScrollPhysics(),
//                 itemCount: widget.horses.length,
//                 itemBuilder: (context, index) {
//                   final horse = widget.horses[index];

//                   // Recherche du client correspondant à idClient du cheval
//                   final owner = clients.firstWhere(
//                     (client) => client.idClient == horse.idClient, 
//                     orElse: () => Client(
//                       idClient: 0, 
//                       nom: 'Inconnu', 
//                       prenom: '', 
//                       tel: '', 
//                       tel2: '', 
//                       email: '', 
//                       societe: '', 
//                       civilite: '', 
//                       isSociete: false, 
//                       derniereVisite: DateTime.now(),
//                       prochaineIntervention: DateTime.now(),
//                       adresse: '',
//                       adresseFacturation: '',
//                       adresses: [],
//                       ville: '',
//                       notes: ''
//                     )
//                   );

//               return Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             horse.name,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "${horse.age} ans",
//                             style: const TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),

//                       if (widget.isFromListHorsePage)
//                         Text(
//                           "${owner.prenom} ${owner.nom}",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                     ],
//                   ),
//                   subtitle: Text(
//                     horse.lastAppointmentDate != null
//                         ? "Dernière visite : ${dateFormatter.format(horse.lastAppointmentDate!)}"
//                         : "Aucune visite",
//                     style: TextStyle(
//                       color: horse.lastAppointmentDate == null ? Colors.grey : Colors.black,
//                     ),
//                   ),
  
//                   trailing: widget.isFromListHorsePage
//                       ? const Icon(Icons.arrow_forward_ios, color: Colors.black) 
//                       : null,
//                   onTap: () {
//                     widget.onHorseTap(horse); 
//                   },
//                 ),
//               );

//                 },
//               ),
//           if (!widget.isFromListHorsePage) 
//             Row(
//               children: [

//                 Expanded(
//                   child: Center(
//                     child: TextButton(
//                       onPressed: () {
//                         setState(() {
//                           _isExpanded = !_isExpanded;
//                         });
//                       },
//                       style: TextButton.styleFrom(
//                         foregroundColor: Constants.white, 
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(_isExpanded ? "" : "Chevaux"),
//                           const SizedBox(width: 8),
//                           Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white),
//                         ],
//                       ),
//                     ),

//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

// }
