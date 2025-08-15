import 'package:equipro/src/services/apiService.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientCardWidget.dart';
import 'package:equipro/src/widgets/card/client/clientAdresseCardWidget.dart';
import 'package:equipro/src/widgets/card/client/listBottumClientCardWidget.dart';
import 'package:equipro/src/widgets/card/noteCardWidget.dart';
import 'dart:convert';

class ManagementClientPage extends StatefulWidget {
  final Users userSelected;
  final String currentUserId;

  const ManagementClientPage({Key? key, required this.userSelected, required this.currentUserId}) : super(key: key);

  @override
  _ManagementClientPageState createState() => _ManagementClientPageState();
}

class _ManagementClientPageState extends State<ManagementClientPage> {
  late Users user;
  String? visitId;

  @override
  void initState() {
    super.initState();
    user = widget.userSelected;
    _loadAddresses();
    _fetchLastAppointmentBetweenProAndCustomer();
    _fetchNoteBetweenProAndCustomer();
  }


Future<void> _loadAddresses() async {
  try {

    final response = await ApiService.getWithAuth("/adresses/user/${user.id}"
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Address> addresses =
          data.map((item) => Address.fromJson(item)).toList();

      setState(() {
        user = user.copyWith(addresses: addresses);
      });
    } else if (response.statusCode == 404) {
      setState(() {
        user = user.copyWith(addresses: []);
      });
      print("Aucune adresse trouvée pour cet utilisateur.");
    } else {
      print('Erreur API : statut ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur lors du chargement des adresses : $e');
  }
}





  void _updateUserAddresses(List<Address> updatedAddresses) {
    setState(() {
      user = user.copyWith(addresses: updatedAddresses);
    });
  }

Future<void> _fetchLastAppointmentBetweenProAndCustomer() async {
  try {

    final response = await ApiService.getWithAuth("/lastVisit/pro/${widget.currentUserId}/customer/${widget.userSelected.id}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data == null || data.isEmpty || data['id'] == null) {
        setState(() {
          user = user.copyWith(
            lastVisitDate: null,
            nextVisitDate: null,
          );
        });
      } else {
        final lastVisit = data['last_visit_date'] != null
            ? DateTime.parse(data['last_visit_date'])
            : null;

        final nextVisit = data['next_visit_date'] != null
            ? DateTime.parse(data['next_visit_date'])
            : null;

        setState(() {
          user = user.copyWith(
            lastVisitDate: lastVisit,
            nextVisitDate: nextVisit,
          );
        });
      }
    } else {
      print("Erreur fetch rendez-vous ici: ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur lors du fetch du dernier rendez-vous: $e");
  }
}


Future<void> _fetchNoteBetweenProAndCustomer() async {
  try {

    final response = await ApiService.getWithAuth("/note/by-user/${user.id}/${widget.currentUserId}");

    // 3. Traitement de la réponse
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data == null || data.isEmpty || data['id'] == null) {
        setState(() {
          user = user.copyWith(notes: null);
          visitId = null;
        });
      } else {
        final notes = data['notes'] as String?;
        final id = data['id'] as String?;

        setState(() {
          user = user.copyWith(notes: notes);
          visitId = id;
        });
      }
    } else {
      print("Erreur fetch note: ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur lors du fetch des notes: $e");
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
                ClientCardWidget(
                  user: user,
                  onUserUpdated: (updatedUser) {
                    setState(() {
                      user = updatedUser;
                    });
                  },
                  openWithCreateClientPage: false,
                  openWithCreateHorsePage: false,
                ),
                const SizedBox(height: 2),
                AddressCardWidget(
                  userSelectedId: widget.userSelected.id,
                  addresses: user.addresses ?? [],
                  openWithCreateClientPage: false,
                  openWithCreateHorsePage: false,
                  openWithManagementHorsePage: false,
                  onAdresseChanged: _updateUserAddresses,
                ),

                const SizedBox(height: 2),
                ListbottumClientcardwidget(
                  lastAppointmentDate: user.lastVisitDate ?? null,
                  nextAppointmentDate: user.nextVisitDate ?? null,
                  idUserPro: widget.currentUserId,
                  idUserCustomer: widget.userSelected.id,
                ),
                const SizedBox(height: 2),
                NotesCardWidget(
                  initialNotes: user.notes ?? "",
                  openWithCreateHorsePage: false,
                  openWithCreateClientPage: false,
                  openWithManagementHorsePage: false,
                  visitId: visitId,
                  proID : widget.currentUserId,
                  customId : widget.userSelected.id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
