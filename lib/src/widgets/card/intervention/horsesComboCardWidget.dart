import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';


class HorsesComboCardWidget extends StatefulWidget {
  final List<Horse> horseList;
  final Horse? selectedHorse;
  final Function(Horse?) onHorseChanged;
  final Function onAddHorsePressed;  
  final bool? isEditing ;

  const HorsesComboCardWidget({
    required this.horseList,
    required this.selectedHorse,
    required this.onHorseChanged,
    required this.onAddHorsePressed, 
    required this.isEditing ,
    Key? key,
  }) : super(key: key);

  @override
  _HorsesComboCardWidgetState createState() =>
      _HorsesComboCardWidgetState();
}

class _HorsesComboCardWidgetState extends State<HorsesComboCardWidget> {
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
                  'Cheval',
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
                          child: DropdownButton<Horse?>(
                            value: widget.selectedHorse,
                            hint: const Text(
                              "Sélectionner un cheval",
                              style: TextStyle(color: Colors.white),
                            ),
                            isExpanded: true,
                            dropdownColor: Constants.appBarBackgroundColor,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(color: Colors.white,fontSize: 16),
                            items: [
                              // Option "Aucune"
                              const DropdownMenuItem<Horse?>(
                                value: null,
                                child: Text("Aucun", style: TextStyle(color: Colors.white)),
                              ),
                              // Autres écuries
                              ...widget.horseList.map((ecurie) {
                                return DropdownMenuItem<Horse?>(
                                  value: ecurie,
                                  child: Text(ecurie.name, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ],
                            onChanged: widget.isEditing  == false ? null : widget.onHorseChanged,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // if (widget.isEditing  == true)
                    // IconButton(
                    //   icon: const Icon(Icons.add, color: Colors.white),
                    //   onPressed: () {
                    //     widget.onAddHorsePressed();  
                    //   },
                    // ),
                  ],
                ),

              ],
            ),
          ),
        ),
      );
  }
}
