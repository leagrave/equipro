import 'package:equipro/style/appColor.dart';
import 'package:flutter/material.dart';

class SwitchableListWidget extends StatefulWidget {
  final ValueChanged<bool> onSwitchChanged;  // Callback pour renvoyer la valeur

  const SwitchableListWidget({Key? key, required this.onSwitchChanged}) : super(key: key);

  @override
  _SwitchableListWidgetState createState() => _SwitchableListWidgetState();
}

class _SwitchableListWidgetState extends State<SwitchableListWidget> {
  bool _isClientList = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, 
      child: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Chevaux', 
                  style: TextStyle(fontSize: 16, color: Colors.white), 
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent, 
                  ),
                  child: Switch(
                    value: _isClientList,
                    onChanged: (value) {
                      setState(() {
                        _isClientList = value;
                      });
                      widget.onSwitchChanged(value); 
                    },
                    activeColor: AppColors.buttonBackgroundColor, 
                    inactiveThumbColor: Colors.grey, 
                    inactiveTrackColor: Colors.grey[300], 
                  ),
                ),
                const Text(
                  'Clients', 
                  style: TextStyle(fontSize: 16, color: Colors.white), 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
