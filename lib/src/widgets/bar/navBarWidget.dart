import 'package:equipro/src/pages/invoice.dart';
import 'package:equipro/src/pages/event/calendar.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/pages/home.dart';
import 'package:equipro/src/pages/agenda.dart';
import 'package:equipro/src/utils/constants.dart';

class MyWidgetBottomNavBar extends StatefulWidget {
  final int initialPageIndex;
  final int? idClient; 

  const MyWidgetBottomNavBar({
    Key? key,
    this.initialPageIndex = 0,
    this.idClient,
  }) : super(key: key);

  @override
  State<MyWidgetBottomNavBar> createState() => _MyWidgetBottomNavBarState();
}

class _MyWidgetBottomNavBarState extends State<MyWidgetBottomNavBar> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex; 
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      MyHomePage(), // Page d'accueil
      MyAgendaPage(idClient: widget.idClient), // Page agenda avec param
      CalendarPage(), // Page des rendez-vous
      InvoicePage(), // Page des factures
    ];

    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'EquiPro',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: false,
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Constants.turquoiseBright),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_agenda_outlined),
            selectedIcon: Icon(Icons.view_agenda, color: Constants.turquoiseBright),
            label: 'Répertoire',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today, color: Constants.turquoiseBright),
            label: 'Rendez-vous',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Constants.turquoiseBright),
            label: 'Factures',
          ),
        ],
      ),
    );
  }
}
