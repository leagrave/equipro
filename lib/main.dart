import 'package:flutter/material.dart';
import 'package:equipro/router/router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth? globalFirebaseAuth; // Instance globale injectable

void main({FirebaseAuth? firebaseAuth}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  globalFirebaseAuth = firebaseAuth;

  // Ne pas initialiser Firebase en mode test si mock déjà injecté
  if (!Platform.environment.containsKey('FLUTTER_TEST') && globalFirebaseAuth == null) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  tz.initializeTimeZones(); // Charge les fuseaux horaires

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c6afe6a67529f71f0d53028f31a9768c@o4509803034050560.ingest.de.sentry.io/4509803104239696';
      options.sendDefaultPii = true;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: const MyApp(),
      ),
    ),
  );

  // Lance l'app au cas où Sentry init ne lance pas runApp (sécurité)
  if (WidgetsBinding.instance == null) {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EquiPro',
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('fr', 'FR'),
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
