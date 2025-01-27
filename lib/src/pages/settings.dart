import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/card/client/clientProfilCardWidget.dart';
import 'package:equipro/src/widgets/card/settingsCardWidget.dart';
import 'package:equipro/src/widgets/settings/settingsWidget.Dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Settings',
        logoPath: Constants.logo, 
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: Constants.appBarBackgroundColor, 
        isBackButtonVisible: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  context.go('/user');
                },
                onUserTap: () {
                  context.go('/user');
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
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
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
