import 'package:flutter/material.dart';
import 'package:equipro/router/router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Charge les fuseaux horaires
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EquiPro',
      locale: const Locale('fr', 'FR'), 
      supportedLocales: [
       const Locale('fr', 'FR'),
      ],
      localizationsDelegates: const [ 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: go, 
    );
  }
}
