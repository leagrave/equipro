import 'package:flutter/material.dart';

// Widget personnalisé pour l'AppBar
class MyWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final Function onNotificationTap;

  const MyWidgetAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF28313E),
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(logoPath), // Logo de l'application
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            onNotificationTap(); // Action personnalisée lors du clic sur l'icône
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
