import 'package:flutter/material.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:go_router/go_router.dart';

class MyWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final Color backgroundColor;
  final bool isBackButtonVisible;
  final bool showNotifications;
  final bool showChat;
  final bool showSearch;
  final bool showSearchEvent;

  const MyWidgetAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
    required this.backgroundColor,
    this.isBackButtonVisible = true,
    this.showNotifications = true,
    this.showChat = true,
    this.showSearch = false,
    this.showSearchEvent = false,
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
                  context.go('/', extra: {'initialPageIndex': 2});
                }
              },
            )
          : null,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              //context.push('/settings');
              context.push('/', extra: {'initialPageIndex': 2}); 
            },
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(logoPath),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Constants.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (showNotifications)
          IconButton(
            icon: const Icon(Icons.notifications, color: Constants.secondaryYellow),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        if (showChat)
          IconButton(
            icon: const Icon(Icons.settings, color: Constants.white),
            onPressed: () {
              context.push('/settings');
            },
          ),
        if (showSearch)
          IconButton(
            icon: const Icon(Icons.search, color: Constants.white),
            onPressed: () {
              context.push('/searchClient');
            },
          ),
        if (showSearchEvent)
          IconButton(
            icon: const Icon(Icons.search, color: Constants.white),
            onPressed: () {
              context.push('/searchEvent');
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
