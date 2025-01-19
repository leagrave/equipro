import 'package:flutter/material.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/style/appColor.dart';
import 'package:equipro/src/widgets/bar/appBarWidget.dart';
import 'package:equipro/src/widgets/form/horseFormWidget.dart';

class CreateHorsePage extends StatefulWidget {
  @override
  _CreateHorsePageState createState() => _CreateHorsePageState();
}

class _CreateHorsePageState extends State<CreateHorsePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String race = '';
  int age = 0;
  String color = '';
  String feedingType = '';
  String activityType = '';
  DateTime? lastVisitDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgetAppBar(
        title: 'Créer un cheval',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: HorseFormWidget(
            formKey: _formKey,
            onSavedName: (value) => name = value!,
            onSavedRace: (value) => race = value!,
            onSavedAge: (value) => age = int.tryParse(value!) ?? 0,
            onSavedColor: (value) => color = value!,
            onSavedFeedingType: (value) => feedingType = value!,
            onSavedActivityType: (value) => activityType = value!,
            onSavedLastVisitDate: (value) => lastVisitDate = value,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final newHorse = Horse(
              id: DateTime.now().millisecondsSinceEpoch, // Générer un ID unique
              idClient: 1,
              ownerId: 1,
              name: name,
              race: race,
              age: age,
              color: color,
              feedingType: feedingType,
              activityType: activityType,
              lastAppointmentDate: lastVisitDate,
            );
            Navigator.pop(context, newHorse); // Retourner le nouveau cheval
          }
        },
        child: Icon(Icons.save),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
    );
  }
}
