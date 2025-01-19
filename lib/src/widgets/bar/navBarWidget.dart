import 'package:equipro/src/pages/meet.dart';
import 'package:equipro/src/pages/settings.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/pages/home.dart';
import 'package:equipro/src/pages/agenda.dart';
import 'package:equipro/src/utils/constants.dart';


class MyWidgetBottomNavBar extends StatefulWidget {
  const MyWidgetBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MyWidgetBottomNavBar> createState() => _MyWidgetBottomNavBarState();
}

class _MyWidgetBottomNavBarState extends State<MyWidgetBottomNavBar> {
  int currentPageIndex = 0; 

  final List<Widget> _pages = [
     MyHomePage(),       // Page d'accueil
     MyAgendaPage(), // Page de répertoire
     MeetPage(), // Page des rendez-vous
     SettingsPage(), // Page des paramètres
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'EquiPro',
        logoPath: Constants.logo, 
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: Constants.appBarBackgroundColor, 
        isBackButtonVisible: false,
      ),

      body: _pages[currentPageIndex],
      
      // Barre de navigation en bas
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
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

