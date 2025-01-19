import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:go_router/go_router.dart'; 

class ButtonHorseListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, 
        ),
        onPressed: () {
          context.go('/listHorse', extra: 1);
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
