import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:intl/intl.dart'; 
import 'package:equipro/src/models/customer.dart'; 

class HorseListWidget extends StatefulWidget {
  final List<Horse> horses;
  final Function(Horse) onHorseTap;
  final bool isFromListHorsePage;

  const HorseListWidget({
    Key? key,
    required this.horses,
    required this.onHorseTap,
    this.isFromListHorsePage = false,
  }) : super(key: key);

  @override
  _HorseListWidgetState createState() => _HorseListWidgetState();
}

class _HorseListWidgetState extends State<HorseListWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFromListHorsePage) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    final int displayLimit = 0;
    final List<Horse> displayedHorses =
        _isExpanded ? widget.horses : widget.horses.take(displayLimit).toList();

    return Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    if (widget.horses.isEmpty)
      const Center(
        child: Text(
          "Aucun cheval trouvé",
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      )
    else
      Column(
        children: displayedHorses.map((horse) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.5),
                title: Text(horse.name),
                subtitle: Text(
                  horse.lastVisitDate != null
                      ? "Dernière visite : ${dateFormatter.format(horse.lastVisitDate!)}"
                      : "Aucune visite",
                ),
                onTap: () => widget.onHorseTap(horse),
              ),
            ),
          );
        }).toList(),
      ),

        if (!widget.isFromListHorsePage && widget.horses.length > displayLimit)
          TextButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(_isExpanded ? "Réduire" : "Voir plus",
            style: const TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
