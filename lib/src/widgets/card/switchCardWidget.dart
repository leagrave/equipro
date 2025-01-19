import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';

class SwitchCardWidget extends StatefulWidget {
  final ValueChanged<bool> onSwitchChanged;

  const SwitchCardWidget({Key? key, required this.onSwitchChanged}) : super(key: key);

  @override
  _SwitchCardWidgetState createState() => _SwitchCardWidgetState();
}

class _SwitchCardWidgetState extends State<SwitchCardWidget> {
  bool _isClientList = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.8), // Fond transparent
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
              const Text(
                  'Clients', 
                  style: TextStyle(fontSize: 16, color: Colors.white), // Texte en blanc
                ),
                Switch(
                  value: _isClientList,
                  onChanged: (value) {
                    setState(() {
                      _isClientList = value;
                    });
                    widget.onSwitchChanged(value); // Appel du callback pour envoyer la nouvelle valeur au parent
                  },
                  activeColor: AppColors.buttonBackgroundColor, // Couleur active
                  inactiveThumbColor: Colors.grey, // Couleur inactive
                  inactiveTrackColor: Colors.grey[300], // Couleur du track inactif
                ),
                const Text(
                  'Chevaux', 
                  style: TextStyle(fontSize: 16, color: Colors.white), // Texte en blanc
                ),
            ],
          ),
        ),
      ),
    );
  }
}
