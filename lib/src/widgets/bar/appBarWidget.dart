import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class MyWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final Color backgroundColor;
  final bool isBackButtonVisible;
  final bool showActions; 

  const MyWidgetAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
    required this.backgroundColor,
    this.isBackButtonVisible = true,
    this.showActions = true, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Constants.white), 
      leading: isBackButtonVisible
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Constants.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
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
              context.push('/settings');
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: showActions
          ? [
              IconButton(
                icon: const Icon(Icons.notifications, color: Constants.secondaryYellow),
                onPressed: () {
                  context.push('/notifications');
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Constants.secondaryBleu),
                onPressed: () {
                  context.push('/messages');
                },
              ),
            ]
          : null, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
