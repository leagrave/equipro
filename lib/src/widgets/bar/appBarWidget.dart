import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart'; 

class MyWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final Function onNotificationTap;
  final Color backgroundColor;
  final bool isBackButtonVisible; // Nouveau paramètre

  const MyWidgetAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
    required this.onNotificationTap,
    required this.backgroundColor,
    this.isBackButtonVisible = true, // Par défaut, le bouton de retour est visible
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: isBackButtonVisible
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                // Vérifier si la pile de navigation peut pop
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); 
                } else {
                  context.go('/');
                }
              },
            )
          : null, 
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Lorsque le logo est cliqué, naviguer vers la page d'accueil avec un index
              context.go('/');
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(logoPath),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Constants.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        // Icône de profil avant l'icône de notification
        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            context.go('/profile');
          },
        ),
        // Icône de notification
        IconButton(
          icon: const Icon(Icons.notifications, color: Constants.white),
          onPressed: () {
            onNotificationTap();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
