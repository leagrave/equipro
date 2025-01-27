import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class MyWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final Function onNotificationTap;
  final Color backgroundColor;
  final bool isBackButtonVisible;
  final bool showActions; 

  const MyWidgetAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
    required this.onNotificationTap,
    required this.backgroundColor,
    this.isBackButtonVisible = true,
    this.showActions = true, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: isBackButtonVisible
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Constants.white),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  context.pop();
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
              context.go('/settings');
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
      actions: showActions
          ? [
              IconButton(
                icon: const Icon(Icons.notifications, color: Constants.secondaryYellow),
                onPressed: () {
                  onNotificationTap();
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Constants.secondaryBleu),
                onPressed: () {
                  context.go('/chat');
                },
              ),
            ]
          : null, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
