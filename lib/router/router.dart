import 'package:equipro/src/pages/event/chat.dart';
import 'package:equipro/src/pages/event/event.dart';
import 'package:equipro/src/pages/event/message.dart';
import 'package:equipro/src/pages/event/notif.dart';
import 'package:equipro/src/pages/event/searchEvent.dart';
import 'package:equipro/src/pages/facture/createFacture.dart';
import 'package:equipro/src/pages/facture/managementInvoice.dart';
import 'package:equipro/src/pages/horse/createHorse.dart';
import 'package:equipro/src/pages/invoice.dart';
import 'package:equipro/src/pages/client/searchClient.dart';
import 'package:equipro/src/pages/user.dart';
import 'package:go_router/go_router.dart';
import 'package:equipro/src/pages/home.dart';
import 'package:equipro/src/pages/login.dart';
import 'package:equipro/src/pages/signup.dart';
import 'package:equipro/src/pages/agenda.dart';
import 'package:equipro/src/pages/event/calendar.dart';
import 'package:equipro/src/pages/settings.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/pages/client/createClient.dart';
import 'package:equipro/src/pages/client/managementClient.dart';
import 'package:equipro/src/pages/horse/listHorse.dart';
import 'package:equipro/src/pages/horse/managementHorse.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/src/models/client.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/models/event.dart';
import 'package:flutter/material.dart';

final GoRouter go = GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page introuvable',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'La route "${state.uri.toString()}" est invalide.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Retourner à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return MyLoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return MySignupPage();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        return SettingsPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>?; 
        final initialPageIndex = arguments?['initialPageIndex'] ?? 0;
        final idClient = arguments?['idClient'] as int?; 
        return MyWidgetBottomNavBar(initialPageIndex: initialPageIndex, idClient: idClient);
      },
      routes: [
        GoRoute(
          path: 'home',
          builder: (context, state) {
            return MyHomePage();
          },
        ),
        GoRoute(
          path: 'agenda',
          builder: (context, state) {
            final arguments = state.extra as Map<String, dynamic>?;
            int? idClient = arguments?['idClient'];
            return MyAgendaPage(idClient: idClient);
          },
        ),
        GoRoute(
          path: 'calendar',
          builder: (context, state) {
            return CalendarPage();
          },
        ),
        GoRoute(
          path: 'listClient',
          builder: (context, state) {
            final arguments = state.extra as Map<String, dynamic>?; 
            int? idClient = arguments?['idClient'];
            return ListClientPage(idClient: idClient);
          },
        ),
        GoRoute(
          path: 'createClient',
          builder: (context, state) {
            return CreateClientPage();
          },
        ),
        GoRoute(
          path: 'searchClient',
          builder: (context, state) {
            return SearchClientPage();
          },
        ),
        GoRoute(
          path: 'createHorse',
          builder: (context, state) {
            final arguments = state.extra as Map<String, dynamic>?; 
            final int? idClient = arguments?['idClient'];
            return CreateHorsePage(idClient: idClient);
          },
        ),
        GoRoute(
          path: 'managementClient',
          builder: (context, state) {
            final client = state.extra as Client?;
            return ManagementClientPage(client: client!);
          },
        ),
        GoRoute(
          path: 'listHorse',
          builder: (context, state) {
            final arguments = state.extra as Map<String, dynamic>?;
            int? idClient = arguments?['idClient'];
            return ListHorsePage(idClient: idClient);
          },
        ),
        GoRoute(
          path: 'managementHorse',
          builder: (context, state) {
            final horse = state.extra as Horse?;
            return ManagementHorsePage(horse: horse!);
          },
        ),
        GoRoute(
          path: 'invoice',
          builder: (context, state) {
            return InvoicePage();
          },
        ),
        GoRoute(
          path: 'listInvoice',
          builder: (context, state) {
            return ListClientPage();
          },
        ),
        GoRoute(
          path: 'managementInvoice',
          builder: (context, state) {
            final invoice = state.extra as Invoice?;
            return ManagementInvoicePage(invoice: invoice!);
          },
        ),
        GoRoute(
          path: 'createInvoice',
          builder: (context, state) {
            return CreateInvoicePage();
          },
        ),
        GoRoute(
          path: 'chat',
          builder: (context, state) {
            final arguments = state.extra as Map<String, dynamic>?;
            int idClient = arguments?['idClient'];
            return ChatPage(idClient: idClient);
          },
        ),
        GoRoute(
          path: 'user',
          builder: (context, state) {
            return EditProfilePage();
          },
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) {
            return NotifsPage();
          },
        ),
        GoRoute(
          path: 'messages',
          builder: (context, state) {
            return MessagesPage();
          },
        ),
        GoRoute(
          path: 'event',
          builder: (context, state) {
            final event = state.extra as Event?;
            return EventPage(event: event!);
          },
        ),
        GoRoute(
          path: 'searchEvent',
          builder: (context, state) {
            return SearchEventPage();
          },
        ),
      ],
    ),
  ],
);

