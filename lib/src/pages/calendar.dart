import 'dart:collection';

import 'package:chem_organizer/src/provider/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final eventsController = EventsController();
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().toLocal();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<dynamic>> events =
      LinkedHashMap<DateTime, List<dynamic>>();

  List<dynamic> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _selectedDay = _focusedDay;
    eventsController.getEvents().then((value) => {events = value});
    _selectedEvents = ValueNotifier(events[_selectedDay] ?? []);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.blue[300]),
          child: TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2050, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.red[400],
                    shape: BoxShape.circle,
                  ),
                  outsideTextStyle: TextStyle(color: Colors.purple)),
              headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  headerPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0)),
              onDaySelected: (
                selectedDay,
                focusedDay,
              ) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _selectedEvents.value = getEventsForDay(selectedDay);
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: getEventsForDay),
        ),
        Expanded(
          child: ValueListenableBuilder<List<dynamic>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child: Card(
                      shadowColor: Colors.orange[300],
                      color: Colors.blue[300],
                      elevation: 15.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0))),
                      child: ListTile(
                        onTap: () => print('${value[index].id}'),
                        title: Text('${value[index].name}'),
                        subtitle: Text('${value[index].date}'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
