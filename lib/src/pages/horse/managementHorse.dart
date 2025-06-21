// import 'package:equipro/src/utils/constants.dart';
// import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
// import 'package:equipro/src/widgets/card/client/clientsComboCardWidget.dart';
// import 'package:equipro/src/widgets/card/ecurie/ecurieCardWidget.dart';
// import 'package:equipro/src/widgets/card/ecurie/ecuriesComboCardWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:equipro/src/models/horse.dart';
// import 'package:equipro/src/models/customer.dart';
// import 'package:equipro/src/models/ecurie.dart';
// import 'package:equipro/src/widgets/card/horse/horseAdresseCardWidget.dart';
// import 'package:equipro/src/widgets/bar/appBarWidget.dart';
// import 'package:equipro/src/widgets/card/horse/horseCardWidget.dart';
// import 'package:equipro/src/widgets/card/noteCardWidget.dart';
// import 'package:equipro/src/widgets/card/horse/listBottumHorseCardWidget.dart';

// class ManagementHorsePage extends StatefulWidget {
//   final Horse horse;

//   const ManagementHorsePage({Key? key, required this.horse}) : super(key: key);

//   @override
//   _ManagementHorsePageState createState() => _ManagementHorsePageState();
// }

// class _ManagementHorsePageState extends State<ManagementHorsePage> {
//   List<Client> clientList = [];
//   Client? selectedClient;

//   List<Ecurie> ecurieList = [];
//   Ecurie? selectedEcurie;

//   bool showClientCard = false;
//   bool showEcurieCard = false;

//     // Champs pour l'écurie
//   int idEcurie = 0;
//   String nameEcurie = "";
//   int ownerId = 0;
//   String adresseEcurie = "";

//   // Champs pour le client
//   int idClient = 0;
//   String nom = '';
//   String prenom = '';
//   String tel = '';
//   String tel2 = '';
//   String email = '';
//   String adressePerso = '';
//   String adresseEcuries = '';
//   String ville = '';
//   String region = '';
//   DateTime derniereVisite = DateTime.now();
//   bool isSociete = false;

//   // Champs pour le cheval
//   String name = '';
//   int age = 0;
//   String race = '';
//   String? color;
//   String? feedingType;
//   String? activityType;
//   DateTime? lastAppointmentDate;
//   String? adresse;
//   String? notes;
//   int? idEcurieCheval;

//   @override
//   void initState() {
//     super.initState();
//     _loadClients();
//     _loadEcuries();
//   }

//   void _loadClients() {
//     setState(() {
//       clientList = [
//         Client(idClient: 1, nom: "Dupont", prenom: "Jean", tel: "0123456789"),
//         Client(idClient: 2, nom: "Martin", prenom: "Pierre", tel: "0123456489"),
//         Client(idClient: 3, nom: "Sophie", prenom: "Lacroix", tel: "0123456489"),
//         Client(idClient: 4, nom: "Eve", prenom: "Gomez", tel: "0123456489"),
//       ];
//     });
//   }

//   void _loadEcuries() {
//     setState(() {
//       ecurieList = [
//         Ecurie(idEcurie: 0, name: "", ownerId: 0, adresse: ""),
//         Ecurie(idEcurie: 1, name: "Ecurie Triomphe", ownerId: 2, adresse: ""),
//         Ecurie(idEcurie: 2, name: "Deven", ownerId: 1, adresse: "rue du pavillon"),
//         Ecurie(idEcurie: 3, name: "Ecurie Entressen", ownerId: 3, adresse: "boulevard de la nuée"),
//         Ecurie(idEcurie: 4, name: "Etoile", ownerId: 4, adresse: ""),
//       ];
//     });
//   }

//   void _onClientChanged(Client? newClient) {
//     setState(() {
//       selectedClient = newClient;
//     });
//   }

//   void _onEcurieChanged(Ecurie? newEcurie) {
//     setState(() {
//       selectedEcurie = newEcurie;
//     });
//   }

//   void _toggleClientCard() {
//     setState(() {
//       showClientCard = !showClientCard;
//     });
//   }

//   void _toggleEcurieCard() {
//     setState(() {
//       showEcurieCard = !showEcurieCard;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Coordonnées fictives (par défaut).
//     final Location defaultLocation = Location(
//       latitude: 45.7579211,
//       longitude: 4.7527296, 
//     );

//     return Scaffold(
//       appBar: const MyWidgetAppBar(
//         title: 'Gestion cheval',
//         logoPath: Constants.logo, 
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
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Appel du widget combo Client
//                 ClientsComboCardWidget(
//                   clientList: clientList,
//                   selectedClient: selectedClient,
//                   onClientChanged: _onClientChanged,
//                   onAddClientPressed: _toggleClientCard,
//                 ),

//               if (showClientCard)
//                 ClientCardWidget(
//                   client: Client(
//                     idClient: 4,  
//                     nom: nom,    
//                     prenom: prenom,
//                     tel: tel,  
//                     email: email, 
//                     isSociete: isSociete, 
//                   ),
//                   onClientUpdated: (updatedClient) {
//                     setState(() {
//                       nom = updatedClient.nom;
//                       prenom = updatedClient.prenom;
//                       tel = updatedClient.tel;
//                       email = updatedClient.email ?? "";
//                       isSociete = updatedClient.isSociete ?? false;
//                     });
//                   },
//                   openWithCreateClientPage: false, 
//                   openWithCreateHorsePage: false,
//                 ),
//               const SizedBox(height: 12),


//                 // Appel du widget combo Ecurie
//                 EcuriesComboCardWidget(
//                   ecurieList: ecurieList,
//                   selectedEcurie: selectedEcurie,
//                   onEcurieChanged: _onEcurieChanged,
//                   onAddEcuriePressed: _toggleEcurieCard,
//                 ),

//                 if (showEcurieCard)
//                 EcurieCardWidget(
//                   idEcurie: idEcurie,
//                   initialName: nameEcurie,
//                   ownerId: ownerId,
//                   adresse: adresseEcurie,
//                   onNameChanged: (value) => setState(() => nameEcurie = value),
//                   onOwnerIdChanged:(value) => setState(() => ownerId = value),
//                   onAdresseChanged: (value) => setState(() => adresseEcurie = value),
//                   onSave: _toggleEcurieCard,
//                 ),

//                 const SizedBox(height: 12),

//                 HorseCardWidget(horse: widget.horse, openWithCreateHorsePage: false),

//                 const SizedBox(height: 12),

//                 // Card avec l'adresse
//                 HorseAddressCardWidget(
//                   address: widget.horse.adresse ?? 'Adresse non renseignée',
//                   location: defaultLocation,
//                   onAddressChanged: (newAddress) {
//                     print("Nouvelle adresse : $newAddress");
//                   },
//                   openWithCreateHorsePage: false,
//                 ),

//                 const SizedBox(height: 12),

//                 ListbottumHorsecardwidget(idClient:widget.horse.idClient),

//                 const SizedBox(height: 12),

//                 NotesCardWidget(
//                   initialNotes: widget.horse.notes ?? "",
//                   openWithCreateHorsePage: false,
//                   openWithCreateClientPage: false,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
