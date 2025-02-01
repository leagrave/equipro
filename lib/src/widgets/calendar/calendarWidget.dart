import 'package:equipro/src/pages/event/event.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:equipro/src/widgets/event/eventDataSourceWidget.dart';
import 'package:equipro/src/models/event.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarView calendarView;
  final List<Event> events; 
  final Function(CalendarView) onViewChanged;

  CalendarWidget({required this.calendarView, required this.events, required this.onViewChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendrier avec la vue dynamique
        Expanded(
          // child: Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white, 
          //     borderRadius: BorderRadius.circular(16), 
          //   ),
            child: SfCalendar(
              view: calendarView,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
                CalendarView.timelineDay,
                CalendarView.schedule,
              ],
              viewHeaderStyle: const ViewHeaderStyle(backgroundColor: Constants.white),
              backgroundColor: const Color.fromARGB(0, 214, 31, 31),  
              initialDisplayDate: DateTime.now(),
              dataSource: EventDataSource(events), 
              todayHighlightColor: Constants.gradientEndColor,
              showNavigationArrow: true,
              cellEndPadding: 5,
              showCurrentTimeIndicator: true,
              showDatePickerButton: true,
              allowViewNavigation: true,
              firstDayOfWeek: 1, // La semaine commence le lundi
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeFormat: 'HH:mm', // Format 24h
                startHour: 7,
                endHour: 20,
                timeIntervalHeight: 50,
  
              ),
              onTap: (CalendarTapDetails details) {
                if (details.appointments != null && details.appointments!.isNotEmpty) {
                  final Event event = details.appointments!.first; 

                  // Formatage des heures en français
                  String heureDebut = DateFormat.Hm('fr_FR').format(event.heureDebut); 
                  String heureFin = DateFormat.Hm('fr_FR').format(event.heureFin); 

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(event.eventName), 
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Text("De $heureDebut à $heureFin"),
                            Text("Client: ${event.idClient}"), 
                            Text("Adresse: ${event.adresseEcurie}"), 
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventPage(event: event), 
                              ),
                            );
                          },
                          child: const Text("Détails"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Fermer"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
       // ),
      ],
    );
  }
}
