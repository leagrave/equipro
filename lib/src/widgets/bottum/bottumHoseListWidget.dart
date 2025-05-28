import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 

class ButtonHorseListWidget extends StatelessWidget {
  final int idClient;

  const ButtonHorseListWidget({Key? key, required this.idClient}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.gradientStartColor, 
        ),
        onPressed: () {
          context.push('/listHorse', extra: {'idClient': idClient});
        },

        child: const Column(
          mainAxisSize: MainAxisSize.min, 
          children: <Widget>[
            Icon(
              Icons.list, 
              color: Colors.white,
              size: 30, 
            ),
            Text(
              "Mes Chevaux",
              style: TextStyle(
                color: Colors.white, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
