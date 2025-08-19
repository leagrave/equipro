import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 

class ButtonHistoVisitListWidget extends StatelessWidget {
  final String? idUser;
  final String? horseId;
  final String? userCustomID;
  final String proID;

  const ButtonHistoVisitListWidget({Key? key, this.idUser, this.horseId, required this.proID, this.userCustomID}) : super(key: key);

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
          context.push('/listIntervention', extra: {'userId': idUser, 'horseId': horseId, 'proID':proID, 'userCustomID': userCustomID});
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
              "Interventions",
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
