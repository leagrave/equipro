import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 

class ButtonHorseListWidget extends StatelessWidget {
  final String proID;
  final String? userCustomID;

  const ButtonHorseListWidget({Key? key, required this.proID, this.userCustomID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), 
          ),
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
        ),
        onPressed: () {
          context.push('/listHorse', extra: {'proID': proID, 'userCustomerID': userCustomID});
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.list,
              color: Constants.gradientStartColor,
              size: 30,
            ),
            Text(
              "Chevaux",
              style: TextStyle(
                color: Constants.gradientStartColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
