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
      children: [
        if (widget.horses.isEmpty)
          const Center(
            child: Text(
              "Aucun cheval trouvé",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,           
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedHorses.length,
              itemBuilder: (context, index) {
                final horse = displayedHorses[index];
                return ListTile(
                  title: Text(horse.name),
                  subtitle: Text(horse.lastVisitDate != null
                      ? "Dernière visite : ${dateFormatter.format(horse.lastVisitDate!)}"
                      : "Aucune visite"),
                  onTap: () => widget.onHorseTap(horse),
                );
              },
            ),
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
