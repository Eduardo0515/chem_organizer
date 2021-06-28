import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  late Map<DateTime,List<dynamic>> _events;
  late List<dynamic> _selectedEvents;

  List<dynamic> _getEventsForDay(DateTime day) {
    // Implementation example
    return [{DateTime.now(): ['Hola','Hola2']}];
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _events = {};
    _selectedEvents = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendario"),
      ),
      body: TableCalendar(
        locale: 'es_ES',
        firstDay: DateTime.utc(2000, 01, 01),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay,) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        eventLoader: _getEventsForDay
      ),
    );
  }
}
