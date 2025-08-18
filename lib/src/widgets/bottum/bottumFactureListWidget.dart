import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 

class ButtonFactureListWidget extends StatelessWidget {
  final String proID;
  final String userCustomID;
  final String? idUser;

  const ButtonFactureListWidget({Key? key, required this.proID, required this.userCustomID, this.idUser }) : super(key: key);
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
          context.push('/listInvoice', extra: {
            'proID': proID
          });
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.receipt,
              color: Constants.gradientStartColor,
              size: 30,
            ),
            Text(
              "Factures",
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
