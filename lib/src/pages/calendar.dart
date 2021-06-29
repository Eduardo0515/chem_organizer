import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:chem_organizer/src/provider/calendar_provider.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<String>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  //Data provider
  final calendarProvider = new CalendarProvider();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(calendarProvider.getEventsForDay(_selectedDay!));
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
        TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2000, 01, 01),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (
              selectedDay,
              focusedDay,
            ) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; 
              });
              _selectedEvents.value = calendarProvider.getEventsForDay(selectedDay);
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: calendarProvider.getEventsForDay),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<String>>(
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
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index]}'),
                      title: Text('${value[index]}'),
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
