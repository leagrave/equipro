import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';


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
        color: Colors.white.withOpacity(0.8),
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
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Switch(
                  value: _isClientList,
                  onChanged: (value) {
                    setState(() {
                      _isClientList = value;
                    });
                    widget.onSwitchChanged(value); 
                  },
                  activeColor: Constants.appBarBackgroundColor, 
                  inactiveThumbColor: Colors.grey, 
                  inactiveTrackColor: Colors.grey[300], 
                ),
                const Text(
                  'Chevaux', 
                  style: TextStyle(fontSize: 16, color: Colors.white), 
                ),
            ],
          ),
        ),
      ),
    );
  }
}
