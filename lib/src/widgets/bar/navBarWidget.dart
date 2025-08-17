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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  

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
  String? currentIdUser;
  String? currentToken;
  bool professional = false;

  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = await _secureStorage.read(key: 'authToken');
    final userJson = await _secureStorage.read(key: 'userData');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        currentIdUser = user['id']?.toString();
        professional = user['professional'] ?? false;
        currentToken = token;
      });
    } else {
      setState(() {
        currentIdUser = null;
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
      MyAgendaPage(userId: currentIdUser),
      homePage,
      CalendarPage(),
      InvoicePage(userId: currentIdUser),
    ];

    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'EquiPro',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: false,
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Constants.appBarBackgroundColor,
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
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
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Agenda',
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
