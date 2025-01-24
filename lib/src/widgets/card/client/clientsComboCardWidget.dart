import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/client.dart';

class ClientsComboCardWidget extends StatefulWidget {
  final List<Client> clientList;
  final Client? selectedClient;
  final Function(Client?) onClientChanged;
  final Function onAddClientPressed;  

  const ClientsComboCardWidget({
    required this.clientList,
    required this.selectedClient,
    required this.onClientChanged,
    required this.onAddClientPressed, 
    Key? key,
  }) : super(key: key);

  @override
  _ClientsComboCardWidgetState createState() =>
      _ClientsComboCardWidgetState();
}

class _ClientsComboCardWidgetState extends State<ClientsComboCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity, 
        child: Card(
          color: Colors.white.withOpacity(0.8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Text(
                  'Propriétaire',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Constants.dark,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<Client?>( 
                        value: widget.selectedClient,
                        hint: Text("Sélectionner un client"),
                        isExpanded: true,
                        items: widget.clientList.map((client) {
                          return DropdownMenuItem<Client?>(
                            value: client,
                            child: Text("${client.nom} ${client.prenom}"),
                          );
                        }).toList(),
                        onChanged: widget.onClientChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        widget.onAddClientPressed();  
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
