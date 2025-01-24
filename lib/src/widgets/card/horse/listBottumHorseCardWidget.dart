import 'package:flutter/material.dart';
import 'package:equipro/src/widgets/bottum/bottumFactureListWidget.dart';
import 'package:equipro/src/widgets/bottum/bottumClientListWidget.dart';

class ListbottumHorsecardwidget extends StatelessWidget {


  const ListbottumHorsecardwidget({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.8), 
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), 
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonClientListWidget(),
                  ButtonFactureListWidget(), 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
