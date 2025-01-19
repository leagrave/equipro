import 'package:flutter/material.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/utils/constants.dart';

class MyAgendaPage extends StatelessWidget {
  const MyAgendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.appBarBackgroundColor, Constants.turquoise],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListClientPage(), 
      ),
    );
  }
}
