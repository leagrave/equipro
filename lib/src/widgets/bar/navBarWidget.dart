import 'package:equipro/src/pages/event/message.dart';
import 'package:equipro/src/pages/homeClient.dart';
import 'package:equipro/src/pages/invoice.dart';
import 'package:equipro/src/pages/event/calendar.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/pages/home.dart';
import 'package:equipro/src/pages/agenda.dart';
import 'package:equipro/src/utils/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class MyWidgetBottomNavBar extends StatefulWidget {
  final int initialPageIndex;


  const MyWidgetBottomNavBar({
    Key? key,
    this.initialPageIndex = 0,

  }) : super(key: key);

  @override
  State<MyWidgetBottomNavBar> createState() => _MyWidgetBottomNavBarState();
}

class _MyWidgetBottomNavBarState extends State<MyWidgetBottomNavBar> {
  late int currentPageIndex;
  String? currentIdClient;
  String? currentToken;
  bool professional = false;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
    _loadUserData();
  }

    Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        currentIdClient = user['id']?.toString();
        professional = user['professional'] ?? false;
        currentToken = token;
      });
    } else {
      setState(() {
        currentIdClient = null;
        currentToken = null;
        professional = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget homePage = professional ? MyHomePage() : MyHomeClientPage();

    final List<Widget> _pages = [
      MessagesPage(),
      MyAgendaPage(idClient: currentIdClient),
      homePage,
      CalendarPage(),
      InvoicePage(),
    ];

    return Scaffold(
      appBar:  MyWidgetAppBar(
        title: 'EquiPro' , //  ${currentIdClient ?? "Invité}
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: false,
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Constants.appBarBackgroundColor,
          indicatorColor: Colors.transparent, // Désactiver l'effet de surbrillance
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white), // Labels en blanc
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: Constants.turquoiseBright, size: 30);
              }
              return const IconThemeData(color: Colors.white, size: 24);
            },
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.message_outlined),
              selectedIcon: Icon(Icons.message),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: Icon(Icons.view_agenda_outlined),
              selectedIcon: Icon(Icons.view_agenda),
              label: 'Répertoire',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined, ), //size: 40,
              selectedIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Rendez-vous',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Factures',
            ),
          ],
        ),
      ),
    );
  }
}
