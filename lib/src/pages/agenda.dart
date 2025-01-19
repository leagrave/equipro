import 'package:flutter/material.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/bar/navBarWidget.dart';
import 'package:equipro/style/appColor.dart';

class MyAgendaPage extends StatelessWidget {
  const MyAgendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Agenda',
        logoPath: 'assets/images/image-logo.jpg',
        onNotificationTap: () {
          print('Notifications');
        },
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListClientPage(), // Affiche uniquement ListClientPage
      ),
      bottomNavigationBar: MyWidgetBottomNavBar(
        onTap: (index) {
          // Navigation selon l'index sélectionné
        },
      ),
    );
  }
}
