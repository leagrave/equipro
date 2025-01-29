import 'package:equipro/src/pages/event/event.dart';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:equipro/src/widgets/event/eventDataSourceWidget.dart';
import 'package:equipro/src/models/event.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarView calendarView;
  final List<Event> events;  // Utiliser Event à la place de Meeting
  final Function(CalendarView) onViewChanged;

  CalendarWidget({required this.calendarView, required this.events, required this.onViewChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendrier avec la vue dynamique
        Expanded(
          child: SfCalendar(
            view: calendarView,
            allowedViews: [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
              CalendarView.timelineDay,
            ],
            viewHeaderStyle: ViewHeaderStyle(backgroundColor: Constants.white),
            backgroundColor: Constants.white,
            initialDisplayDate: DateTime.now(),
            dataSource: EventDataSource(events), 
            todayHighlightColor: Constants.gradientEndColor,
            showNavigationArrow: true,
            cellEndPadding: 5,
            showCurrentTimeIndicator: true,
            showWeekNumber: true,
            firstDayOfWeek: 1, // La semaine commence le lundi
            timeSlotViewSettings: const TimeSlotViewSettings(
              timeFormat: 'HH:mm', // Format 24h
              startHour: 7,
              endHour: 20,
              timeIntervalHeight: 50,
            ),
            onTap: (CalendarTapDetails details) {
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final Event event = details.appointments!.first; // Utiliser Event

                // Formatage des heures en français
                String heureDebut = DateFormat.Hm('fr_FR').format(event.heureDebut); // Utiliser heureDebut
                String heureFin = DateFormat.Hm('fr_FR').format(event.heureFin); // Utiliser heureFin

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(event.eventName), // Utiliser eventName
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text("De $heureDebut à $heureFin"),
                          Text("Client: ${event.idClient}"), // Utiliser idClient ou d'autres détails si nécessaire
                          Text("Adresse: ${event.adresseEcurie}"), // Utiliser adresseEcurie
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Ferme l'alerte
                          // Navigue vers la page de détails
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventPage(event: event), // Utiliser EventPage avec Event
                            ),
                          );
                        },
                        child: Text("Détails"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Fermer"),
                      ),
                    ],
                  ),
                );

              }
            },
          ),
        ),
      ],
    );
  }
}
