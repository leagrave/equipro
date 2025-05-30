import 'package:flutter/material.dart';
import 'package:equipro/router/router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <- utilisation ici
  );
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
