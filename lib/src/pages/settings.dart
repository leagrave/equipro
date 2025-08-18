import 'package:equipro/src/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:go_router/go_router.dart';
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
  final _storage = const FlutterSecureStorage(); 

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
  final token = await _storage.read(key: 'authToken');
  final userJson = await _storage.read(key: 'userData');

  if (userJson != null) {
    final userMap = jsonDecode(userJson);
    final userId = userMap['id']?.toString();

    setState(() {
      currentIdUser = userId;
      currentToken = token;
      professional = userMap['professional'] ?? false;
      currentUser = Users.fromJson(userMap); 
    });

    if (userId != null && token != null) {
      fetchCurrentUser(userId, token).then((user) {
        if (user != null) {
          setState(() {
            currentUser = user;
          });
        }
      }).catchError((error) {
        debugPrint('Erreur fetch user : $error');
      });
    }
  }
}

  Future<Users?> fetchCurrentUser(String userId, String token) async {
    final response = await ApiService.getWithAuth('/user/pro/$userId');

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Users.fromJson(json);
    } else {
      debugPrint('Erreur lors du chargement de l’utilisateur : ${response.statusCode} ${response.body}');
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
    await _storage.delete(key: 'userData');

    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyWidgetAppBar(
        title: 'Settings',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (currentUser != null)
                      UserCard(
                        profileImageUrl: Constants.avatar,
                        firstName: currentUser!.firstName,
                        lastName: currentUser!.lastName,
                        isProfessional: currentUser!.professional,
                        isVerified: currentUser!.isVerified ?? false,
                        onEditProfile: () {
                          context.push('/profile', extra: {'currentUser': currentUser});
                        },
                        onUserTap: () {
                          context.push('/profile', extra: {'currentUser': currentUser});
                        },
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 12),
                    SettingsScreen(),
                    const SizedBox(height: 24),
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
          },
        ),
      ),
    );
  }
}