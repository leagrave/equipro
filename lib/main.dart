import 'package:flutter/material.dart';
import 'package:equipro/router/router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
// const firebaseConfig = {
//   apiKey: "AIzaSyAJujsK_ujwDcW48jBXyP9ecBYGp68PrEQ",
//   authDomain: "equipro-messagerie.firebaseapp.com",
//   projectId: "equipro-messagerie",
//   storageBucket: "equipro-messagerie.firebasestorage.app",
//   messagingSenderId: "706095522218",
//   appId: "1:706095522218:web:66d53a4dd6ca2b3f284bd3",
//   measurementId: "G-2922XS9CNY"
//};

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env"); // charge .env ou autre selon build
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <- utilisation ici
  );

  tz.initializeTimeZones(); // Charge les fuseaux horaires

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://c6afe6a67529f71f0d53028f31a9768c@o4509803034050560.ingest.de.sentry.io/4509803104239696';
      // Adds request headers and IP for users,
      // visit: https://docs.sentry.io/platforms/dart/data-management/data-collected/ for more info
      options.sendDefaultPii = true;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: MyApp(),
      ),
    ),
  );
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
