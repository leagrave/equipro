import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/settings/settingsWidget.Dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsCardWidget extends StatefulWidget {


  const SettingsCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsCardWidgetState createState() => _SettingsCardWidgetState();
}

class _SettingsCardWidgetState extends State<SettingsCardWidget> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.1),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(child: SettingsScreen()),

              

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

              const SizedBox(height: 5),
              const Text("test")
            ],
          ),
        ),
      ),
    );
  }
}
