import 'package:flutter/material.dart';
import 'package:equipro/src/pages/home.dart';
import 'package:equipro/src/pages/login.dart';
import 'package:equipro/src/pages/signUp.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/pages/client/createClient.dart';
import 'package:equipro/src/pages/client/managementClient.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/pages/horse/listHorse.dart'; // Importer la page des factures
import 'package:equipro/src/pages/facture/listFacture.dart'; // Importer la page des chevaux

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => MyLoginPage());
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => MySignupPage());
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
      case '/horse':
        return MaterialPageRoute(builder: (_) => ListHorsePage());

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
