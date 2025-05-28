import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientProfilCardWidget.dart';
import 'package:equipro/src/widgets/settings/settingsWidget.Dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
   
              UserCard(
                profileImageUrl: Constants.avatar,
                firstName: 'Jean',
                lastName: 'Dupont',
                isProfessional: false,
                isVerified: true,
                onEditProfile: () {
                  context.push('/user');
                },
                onUserTap: () {
                  context.push('/user');
                },
              ),


              // Expanded(
              //   child: SettingsCardWidget(),
              // ),

              Expanded(
                child: SettingsScreen(),
              ),

              // Bouton de déconnexion
              ElevatedButton(
                onPressed: () {
                  context.go('/login'); 
                },
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
      ),
    );
  }
}
