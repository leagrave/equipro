import 'package:flutter/material.dart';
import 'package:equipro/src/pages/client/listClient.dart';
import 'package:equipro/src/utils/constants.dart';

class MyAgendaPage extends StatelessWidget {
  final int? idClient;

  const MyAgendaPage({Key? key, this.idClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListClientPage(idClient: idClient), 
      ),
    );
  }
}
