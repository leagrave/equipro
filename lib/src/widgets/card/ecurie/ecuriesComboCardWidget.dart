import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/ecurie.dart';

class EcuriesComboCardWidget extends StatefulWidget {
  final List<Ecurie> ecurieList;
  final Ecurie? selectedEcurie;
  final Function(Ecurie?) onEcurieChanged;
  final Function onAddEcuriePressed;  
  final bool? isEditing ;

  const EcuriesComboCardWidget({
    required this.ecurieList,
    required this.selectedEcurie,
    required this.onEcurieChanged,
    required this.onAddEcuriePressed, 
    required this.isEditing ,
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
                    color: Constants.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Ecurie?>(
                            value: widget.selectedEcurie,
                            hint: const Text(
                              "Sélectionner une écurie",
                              style: TextStyle(color: Colors.white),
                            ),
                            isExpanded: true,
                            dropdownColor: Constants.appBarBackgroundColor,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(color: Colors.white,fontSize: 16),
                            items: [
                              // Option "Aucune"
                              const DropdownMenuItem<Ecurie?>(
                                value: null,
                                child: Text("Aucune", style: TextStyle(color: Colors.white)),
                              ),
                              // Autres écuries
                              ...widget.ecurieList.map((ecurie) {
                                return DropdownMenuItem<Ecurie?>(
                                  value: ecurie,
                                  child: Text(ecurie.name, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ],
                            onChanged: widget.isEditing  == false ? null : widget.onEcurieChanged,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (widget.isEditing  == true)
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
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
      );
  }
}
