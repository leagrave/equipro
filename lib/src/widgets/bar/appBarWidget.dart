import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart'; 

class MyWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final Function onNotificationTap;
  final Color backgroundColor;
  final bool isBackButtonVisible; 

  const MyWidgetAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
    required this.onNotificationTap,
    required this.backgroundColor,
    this.isBackButtonVisible = true, 
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
                  Navigator.pop(context); 
              },
            )
          : null, 
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
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

        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            context.go('/settings'); 
          },
        ),

        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            context.go('/profile'); 
          },
        ),

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
