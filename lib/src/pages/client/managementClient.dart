import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/client/listBottumClientCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManagementClientPage extends StatefulWidget {
  final Users userSelected;

  const ManagementClientPage({Key? key, required this.userSelected}) : super(key: key);

  @override
  _ManagementClientPageState createState() => _ManagementClientPageState();
}

class _ManagementClientPageState extends State<ManagementClientPage> {
  late Users user;

  @override
  void initState() {
    super.initState();
    user = widget.userSelected;
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final response = await http.get(Uri.parse("${Constants.apiBaseUrl}/adresses/user/${user.id}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Address> addresses = data.map((item) => Address.fromJson(item)).toList();

        setState(() {
          user = user.copyWith(addresses: addresses);
        });
      } else {
        print('Erreur API : statut ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors du chargement des adresses : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Gestion client',
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ClientCardWidget(
                //   user: user,
                //   onClientUpdated: (updatedClient) {
                //     setState(() {
                //       user = updatedClient;
                //     });
                //   },
                //   openWithCreateClientPage: false,
                //   openWithCreateHorsePage: false,
                // ),
                const SizedBox(height: 2),
                if (user.addresses != null && user.addresses!.isNotEmpty)
                  ...user.addresses!.map((address) => AddressCardWidget(
                        addresses: [address.adresse],
                        location: Location(
                          latitude: address.latitude ?? 0.0,
                          longitude: address.longitude ?? 0.0,
                        ),
                        openWithCreateClientPage: false,
                      )),
                const SizedBox(height: 2),
                // ListbottumClientcardwidget(
                //   lastAppointmentDate: user.derniereVisite ?? DateTime.now(),
                //   nextAppointmentDate: user.prochaineIntervention ?? DateTime.now(),
                //   idUser: user.id,
                // ),
                // const SizedBox(height: 2),
                // NotesCardWidget(
                //   initialNotes: user.notes ?? "",
                //   openWithCreateHorsePage: false,
                //   openWithCreateClientPage: false,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
