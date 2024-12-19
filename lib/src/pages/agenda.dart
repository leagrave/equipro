import 'package:flutter/material.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/pages/horse/listHorse.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/router/router.dart';
import 'package:equipro/src/widgets/bar/switchWidget.dart';

class MyAgendaPage extends StatefulWidget {
  final bool isClientList;  // Paramètre pour l'état initial

  const MyAgendaPage({Key? key, required this.isClientList}) : super(key: key); // Valeur par défaut true

  @override
  _MyAgendaPageState createState() => _MyAgendaPageState();
}

class _MyAgendaPageState extends State<MyAgendaPage> {
  late bool _isClientList;  // Initialise la valeur de _isClientList

  @override
  void initState() {
    super.initState();
    _isClientList = widget.isClientList;  // Utilise la valeur passée en paramètre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Agenda',
        logoPath: 'assets/images/image-logo.jpg',
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SwitchableListWidget(
              onSwitchChanged: (value) {
                setState(() {
                  _isClientList = value;  // Met à jour la valeur du parent
                });
              },
            ),
            Expanded(
              child: _isClientList
                  ? ListClientPage()
                  : const ListHorsePage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyWidgetBottomNavBar(
        onTap: (index) {
          // Navigation selon l'index sélectionné
        },
      ),
    );
  }
}
