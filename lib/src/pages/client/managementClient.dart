import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/client/listBottumClientCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';

class ManagementClientPage extends StatefulWidget {
  final Client client;


  const ManagementClientPage({Key? key, required this.client}) : super(key: key);

  @override
  _ManagementClientPageState createState() => _ManagementClientPageState();
}

class _ManagementClientPageState extends State<ManagementClientPage> {
  late Client client;

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  @override
  Widget build(BuildContext context) {
    // Sélectionnez la première adresse de la liste pour l'affichage.
    final String selectedAddress = (client.adresses != null && client.adresses!.isNotEmpty)
        ? client.adresses!.first
        : 'Adresse non disponible';

    final Location defaultLocation = Location(latitude: 45.7579211, longitude: 4.7527296);

    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Gestion client',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClientCardWidget(
                  client: client,
                  onClientUpdated: (updatedClient) {
                    setState(() {
                      client = updatedClient;
                    });
                  },
                  openWithCreateClientPage: false,
                  openWithCreateHorsePage: false,
                ),
                const SizedBox(height: 2),
                AddressCardWidget(
                  addresses: client.adresses,
                  location: defaultLocation,
                  openWithCreateClientPage: false,
                ),
                const SizedBox(height: 2),
                ListbottumClientcardwidget(
                  lastAppointmentDate: client.derniereVisite ?? DateTime.now(),
                  nextAppointmentDate: client.prochaineIntervention ?? DateTime.now(),
                  idClient: client.idClient,
                ),
                const SizedBox(height: 2),
                NotesCardWidget(
                  initialNotes: client.notes ?? "",
                  openWithCreateHorsePage: false,
                  openWithCreateClientPage: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
