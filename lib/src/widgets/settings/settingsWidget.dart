import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationPermissionGranted = false;
  bool photoPermissionGranted = false;
  String selectedLanguage = 'Français';
  bool isOnline = true;
  double storageSpaceLeft = 50.0; // en Go
  TimeOfDay workStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay workEndTime = const TimeOfDay(hour: 18, minute: 0);

  void toggleNotifications(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  void toggleLocationPermission(bool value) {
    setState(() {
      locationPermissionGranted = value;
    });
  }

  void togglePhotoPermission(bool value) {
    setState(() {
      photoPermissionGranted = value;
    });
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  void updateWorkHours(TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      workStartTime = startTime;
      workEndTime = endTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.white.withOpacity(0.1), 
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications
            SwitchListTile(
              title: const Text('Activer les notifications', style: TextStyle(color: Colors.white)),
              value: notificationsEnabled,
              onChanged: toggleNotifications,
              activeColor: Constants.appBarBackgroundColor,
            ),

            // Heure de travail
            ListTile(
              title: const Text('Heures de travail', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'De ${workStartTime.format(context)} à ${workEndTime.format(context)}',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () async {
                final TimeOfDay? newStartTime = await showTimePicker(
                  context: context,
                  initialTime: workStartTime,
                );
                final TimeOfDay? newEndTime = await showTimePicker(
                  context: context,
                  initialTime: workEndTime,
                );
                if (newStartTime != null && newEndTime != null) {
                  updateWorkHours(newStartTime, newEndTime);
                }
              },
            ),

            // Autorisation de localisation
            SwitchListTile(
              title: const Text('Autoriser l\'accès à la position', style: TextStyle(color: Colors.white)),
              value: locationPermissionGranted,
              onChanged: toggleLocationPermission,
              activeColor: Constants.appBarBackgroundColor,
            ),

            // Autorisation de photo
            SwitchListTile(
              title: const Text('Autoriser l\'accès aux photos', style: TextStyle(color: Colors.white)),
              value: photoPermissionGranted,
              onChanged: togglePhotoPermission,
              activeColor: Constants.appBarBackgroundColor,
            ),

            // Langue
            ListTile(
              title: const Text('Changer la langue', style: TextStyle(color: Colors.white)),
              subtitle: Text(selectedLanguage, style: const TextStyle(color: Colors.white)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choisir une langue', style: TextStyle(color: Colors.white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Français', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              changeLanguage('Français');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Anglais', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              changeLanguage('Anglais');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Espace de stockage disponible
            ListTile(
              title: const Text('Espace de stockage restant', style: TextStyle(color: Colors.white)),
              subtitle: Text('${storageSpaceLeft} Go', style: const TextStyle(color: Colors.white)),
            ),

            // Statut de l'application (en ligne ou hors ligne)
            SwitchListTile(
              title: const Text('Statut en ligne', style: TextStyle(color: Colors.white)),
              activeColor: Constants.appBarBackgroundColor,
              value: isOnline,
              onChanged: (bool value) {
                setState(() {
                  isOnline = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
