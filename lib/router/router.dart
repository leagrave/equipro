import 'package:flutter/material.dart';
import 'package:equipro/src/pages/home.dart';
import 'package:equipro/src/pages/login.dart';
import 'package:equipro/src/pages/signUp.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/pages/client/createClient.dart';
import 'package:equipro/src/pages/client/managementClient.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/pages/horse/listHorse.dart'; 
import 'package:equipro/src/pages/horse/managementHorse.dart'; 
import 'package:equipro/src/pages/facture/listFacture.dart'; 
import 'package:equipro/src/pages/agenda.dart';


class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => MyLoginPage());
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => MySignupPage());
      case '/agenda':
        return MaterialPageRoute(builder: (_) => MyAgendaPage());
      case '/listClient':
        return MaterialPageRoute(builder: (_) => ListClientPage());
      case '/createClient':
        return MaterialPageRoute(builder: (_) => CreateClientPage());
      case '/managementClient':
        // Vérifier si des arguments sont passés
        final client = settings.arguments as Client?;
        if (client != null) {
          return MaterialPageRoute(
            builder: (_) => ManagementClientPage(client: client), // Passer le client
          );
        }
        return _errorRoute();

      // Ajouter les nouvelles routes ici
      case '/facture':
        return MaterialPageRoute(builder: (_) => ListfacturePage());
      case '/listHorse':
        // Vérifier si des arguments sont passés
        final arguments = settings.arguments as Map<String, dynamic>?;

        // Récupérer l'idClient des arguments s'il existe
        final int? idClient = arguments?['idClient'];

        return MaterialPageRoute(
          builder: (_) => ListHorsePage(idClient: idClient), // Passer idClient à la page
        );
        
      case '/createHorse':
        return MaterialPageRoute(builder: (_) => CreateClientPage());
      case '/managementHorse':
        // Vérifier si des arguments sont passés
        final horse = settings.arguments as Horse?;
        if (horse != null) {
          return MaterialPageRoute(
            builder: (_) => ManagementHorsePage(horse: horse), // Passer le client
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Erreur')),
        body: Center(child: Text('Page non trouvée')),
      ),
    );
  }
}
