import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientProfilCardWidget.dart';
import 'package:equipro/src/widgets/settings/settingsWidget.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/models/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? currentIdUser;
  String? currentToken;
  bool professional = false;
  Users? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (userJson != null && token != null) {
      final userMap = jsonDecode(userJson);
      final userId = userMap['id']?.toString();

      setState(() {
        currentIdUser = userId;
        currentToken = token;
        professional = userMap['professional'] ?? false;
      });

      if (userId != null && token != null) {
        // Ensuite on charge le vrai user depuis l'API
        final user = await fetchCurrentUser(userId, token);
        if (user != null) {
          setState(() {
            currentUser = user;
          });
          debugPrint("User chargé : ${user.firstName}");
        }
      } else {
        setState(() {
          currentIdUser = null;
          currentToken = null;
          professional = false;
        });
      }
    }
  }

  Future<Users?> fetchCurrentUser(String userId, String token) async {
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/user/pro/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Users.fromJson(json);
    } else {
      debugPrint('Erreur lors du chargement de l’utilisateur : ${response.statusCode} ${response.body}');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Settings',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            UserCard(
              profileImageUrl: Constants.avatar, // ou currentUser!.avatarUrl ?? Constants.avatar
              firstName: currentUser!.firstName,
              lastName: currentUser!.lastName,
              isProfessional: currentUser!.professional ?? false,
              isVerified: currentUser!.isVerified ?? false,
              onEditProfile: () {
                context.push('/profile', extra: {
                  'currentUser': currentUser,
                });
              },
              onUserTap: () {
                context.push('/profile', extra: {
                  'currentUser': currentUser,
                });
              },
            ),
            Expanded(child: SettingsScreen()),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.secondaryRed,
                foregroundColor: Constants.white,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Déconnexion'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
