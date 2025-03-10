import 'package:flutter/material.dart';

class HorizontalScrollWidget extends StatefulWidget {
  @override
  _HorizontalScrollWidgetState createState() =>
      _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  // Pour afficher la bulle d'information de chaque bouton
  String? selectedText;
  int? selectedIndex;

  final List<Map<String, dynamic>> items = [
    {'number': '5', 'text': 'Messages non lus', 'info': 'Vous avez 5 messages non lus.'},
    {'number': '3', 'text': 'Annulation', 'info': 'Il y a 3 annulations à traiter.'},
    {'number': '2', 'text': 'Modification', 'info': '2 modifications en attente.'},
    {'number': '4', 'text': 'Rendez-vous', 'info': '4 rendez-vous prévus pour aujourd’hui.'},
    {'number': '5', 'text': 'Non payés', 'info': '4 factures non payées'},
    {'number': '', 'text': 'En ligne', 'info': 'État : En ligne', 'isOnline': true},
  ];

  void _showInfo(String info, int index) {
    setState(() {
      selectedText = info;
      selectedIndex = index;
    });
  }

  void _dismissInfo() {
    setState(() {
      selectedText = null;
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissInfo, // Ferme la bulle lorsque l'utilisateur clique à côté
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.map((item) {
                int index = items.indexOf(item);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => _showInfo(item['info']!, index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Circle button with number and icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Center(
                            child: item['number']!.isEmpty
                                ? Icon(
                                    Icons.circle,
                                    color: item['isOnline'] == true
                                        ? Colors.green
                                        : Colors.red,
                                    size: 30,
                                  )
                                : Text(
                                    item['number']!,
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item['text']!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedText != null && selectedIndex != null) // Affiche la bulle d'information
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Material(
                color: Colors.transparent,
                child: CustomPaint(
                  painter: BubblePainter(selectedIndex!),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Text(
                      selectedText!,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final int selectedIndex;
  BubblePainter(this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Define the position of the triangle (arrow) pointing to the selected button
    final double triangleHeight = 10;
    final double arrowX = 60.0 * selectedIndex + 40.0; // X position of the arrow (based on index)

    // Draw the rounded rectangle for the bubble
    final rect = Rect.fromLTWH(arrowX - 10, 0, 200, 60);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));
    canvas.drawRRect(rrect, paint);

    // Draw the triangle arrow pointing to the button
    final path = Path()
      ..moveTo(arrowX, 60)
      ..lineTo(arrowX - triangleHeight, 60 + triangleHeight)
      ..lineTo(arrowX + triangleHeight, 60 + triangleHeight)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
