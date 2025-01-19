import 'package:flutter/material.dart';
import 'package:equipro/style/appColor.dart';
import 'package:go_router/go_router.dart';

class ButtonClientListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientStartColor, 
        ),
        onPressed: () {
          //context.go('/agenda', extra: true);
          // Navigator.pushNamed(
          //   context,
          //   '/agenda',
          //   arguments: true, 
          // );
          context.go('/',  extra: true);  

        },

        child: Text(
          "Propriètaire",
          style: TextStyle(
            color: Colors.white, 
          ),
        ),
      ),
    );
  }
}
