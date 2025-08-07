import 'package:equipro/src/pages/event/chat.dart';
import 'package:equipro/src/pages/event/createConversationPage.dart';
import 'package:equipro/src/pages/event/event.dart';
import 'package:equipro/src/pages/event/message.dart';
import 'package:equipro/src/pages/event/notif.dart';
import 'package:equipro/src/pages/event/searchEvent.dart';
import 'package:equipro/src/pages/facture/createFacture.dart';
import 'package:equipro/src/pages/facture/managementInvoice.dart';
import 'package:equipro/src/pages/horse/createHorse.dart';
import 'package:equipro/src/pages/intervention/createIntervention.dart';
import 'package:equipro/src/pages/intervention/listInterventionHorse.dart';
import 'package:equipro/src/pages/invoice.dart';
import 'package:equipro/src/pages/client/searchClient.dart';
import 'package:equipro/src/pages/profile.dart';
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
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/invoice.dart';
import 'package:equipro/src/models/event.dart';
import 'package:flutter/material.dart';
import 'package:equipro/router/splash.dart';

final GoRouter go = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => MyLoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => MySignupPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        final arguments = state.extra as Map<String, dynamic>?;
        final initialPageIndex = arguments?['initialPageIndex'] ?? 0;
        return MyWidgetBottomNavBar(
          initialPageIndex: initialPageIndex,
        );
      },
      routes: [
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
        return MyWidgetBottomNavBar(
          initialPageIndex: initialPageIndex,

        );
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
            String? userId = arguments?['idUser'];
            return MyAgendaPage(userId: userId);
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
            final userId = state.extra as String;
            return ListClientPage(userId: userId);
          },
        ),
        GoRoute(
          path: 'createClient',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final proID = extra['proID'] as String;
            final openWithCreateHorsePage = extra['openWithCreateHorsePage'] as bool? ?? false;
            return CreateClientPage(
              proID: proID,
              openWithCreateHorsePage: openWithCreateHorsePage,
            );
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
            final extra = state.extra as Map<String, dynamic>;
            final proID = extra['proID'] as String;
            final userCustomId = extra['userCustomId'] as String?;
            final userCreate = extra['customer'] as Users?;

            return CreateHorsePage(
              proID: proID,
              customer: userCreate,
              userCustomId: userCustomId,
            );
          },
        ),
        GoRoute(
          path: 'managementClient',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final userSelect = extra['userSelected'] as Users;
            final currentUserId = extra['currentUserId'] as String;

            return ManagementClientPage(
              userSelected: userSelect,
              currentUserId: currentUserId,
            );
          },
        ),
        GoRoute(
          path: 'listHorse',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final proID = extra['proID'] as String;
            final userCustomerId = extra['userCustomerID'] as String?;
            return ListHorsePage(proID: proID, userCustomerID: userCustomerId);
          },
        ),
        GoRoute(
          path: 'managementHorse',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final horseID = extra['horseId'] as String; 
            final proID = extra['proID'] as String;
            return ManagementHorsePage(
              horseId: horseID,
              proID: proID,
            );
          },

        ),
        GoRoute(
          path: 'invoice',
          builder: (context, state) {
            final userId = state.extra as String;
            return InvoicePage(userId: userId);
          },
        ),
        GoRoute(
          path: 'listInvoice',
          builder: (context, state) {
            final userId = state.extra as String;
            return ListClientPage(userId: userId,);
          },
        ),
        // GoRoute(
        //   path: 'managementInvoice',
        //   builder: (context, state) {
        //     final invoice = state.extra as Invoice?;
        //     return ManagementInvoicePage(invoice: invoice!);
        //   },
        // ),
        // GoRoute(
        //   path: 'createInvoice',
        //   builder: (context, state) {
        //     return CreateInvoicePage();
        //   },
        // ),
        GoRoute(
          path: 'createIntervention',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final userId = extra['userId'] as String?;
            final horseId = extra['horseId']as String?;
            final proID = extra['proID'] as String;
            return CreateInterventionPage(userId: userId, horseId: horseId, proId: proID,);
          },
        ),
        GoRoute(
          path: 'listIntervention',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final userId = extra['userId'] as String?;
            final horseId = extra['horseId']as String?;
            final proID = extra['proID'] as String;
            return HorseInterventionListWidget(userId: userId, horseId: horseId, proID: proID,);
          },
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) {
            final conversationId = state.pathParameters['id']!; 
            final currentUserId = state.extra as String;
            return ChatPage(
              conversationId: conversationId,
              currentUserId: currentUserId,
              );
          },
        ),

        GoRoute(
          path: 'profile',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final currentUser = extra['currentUser'] as Users;
            return EditProfilePage(currentUser: currentUser);
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
          path: '/createConv',
          builder: (context, state) {
            return CreateConversationPage();
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
    ),
  ],
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
              onPressed: () => context.go('/', extra: {'initialPageIndex': 2}),
              child: const Text('Retourner à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  },
);

