import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/ecurie.dart';

class EcuriesComboCardWidget extends StatefulWidget {
  final List<Ecurie> ecurieList;
  final Ecurie? selectedEcurie;
  final Function(Ecurie?) onEcurieChanged;
  final Function onAddEcuriePressed;  

  const EcuriesComboCardWidget({
    required this.ecurieList,
    required this.selectedEcurie,
    required this.onEcurieChanged,
    required this.onAddEcuriePressed, 
    Key? key,
  }) : super(key: key);

  @override
  _EcuriesComboCardWidgetState createState() =>
      _EcuriesComboCardWidgetState();
}

class _EcuriesComboCardWidgetState extends State<EcuriesComboCardWidget> {
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
                  'Ecuries',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Constants.dark,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<Ecurie?>( 
                        value: widget.selectedEcurie,
                        hint: Text("Sélectionner une écurie"),
                        isExpanded: true,
                        items: widget.ecurieList.map((ecurie) {
                          return DropdownMenuItem<Ecurie?>(
                            value: ecurie,
                            child: Text(ecurie.name),
                          );
                        }).toList(),
                        onChanged: widget.onEcurieChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        widget.onAddEcuriePressed();  
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
