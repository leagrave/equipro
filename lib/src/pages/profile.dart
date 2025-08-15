import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/form/signUpFormWidget.dart';

class EditProfilePage extends StatefulWidget {
  final Users currentUser;

  const EditProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool enSaisie = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Profil',
        logoPath: Constants.logo,
        backgroundColor: Constants.appBarBackgroundColor,
        isBackButtonVisible: true,
        showEdit: true,
        onEditPressed: () {
          setState(() {
            enSaisie = !enSaisie;
          });
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SignUpFormWidget(
                currentUser: widget.currentUser,
                enSaisie: enSaisie,
                  onCancel: () {
                    setState(() {
                      enSaisie = false;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
