import 'dart:collection';

import 'package:chem_organizer/src/models/event.dart';
import 'package:chem_organizer/src/pages/edit_event.dart';
import 'package:chem_organizer/src/provider/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:chem_organizer/src/provider/categories_controller.dart';

import 'info_event.dart';

class CalendarPage extends StatefulWidget {
  final String user;
  const CalendarPage({Key? key, required this.user});

  @override
  State<CalendarPage> createState() => new _CalendarPageState(this.user);
}

class _CalendarPageState extends State<CalendarPage> {
  final String user;
  String nombre = "";
  DateTime fecha = DateTime.now();
  String categoria = "";
  int tiempoNotificacion = 10;
  String idCategoria = "todos";
  late CategoriesController categoriesController =
      new CategoriesController(user);

  final eventsController = EventsController();
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now().toLocal();
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<dynamic>> events =
      LinkedHashMap<DateTime, List<dynamic>>();

  _CalendarPageState(this.user);

  List<dynamic> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _selectedDay = _focusedDay;
    eventsController.getEvents(this.user).then((value) => {events = value});
    _selectedEvents = ValueNotifier(events[_selectedDay] ?? []);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(133, 45, 145, 1.0),
          Color.fromRGBO(49, 42, 108, 1.0),
        ],
      )),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(209, 204, 210, 1.0),
            ),
            child: TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime.utc(2000, 01, 01),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.pink.shade300,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      shape: BoxShape.circle,
                    ),
                    outsideTextStyle: TextStyle(color: Colors.purple)),
                headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.shade100,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  headerPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                ),
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
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.fromLTRB(45, 0, 55, 0),
                                onTap: () => print('${value[index].id}'),
                                title: Text(
                                  '${value[index].name}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                subtitle: Text(
                                  eventsController
                                      .getDateFromDateTime(value[index].date),
                                  style: TextStyle(
                                      height: 1.5, color: Colors.white70),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Column(children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: Color.fromRGBO(238, 211, 110, 0.7),
                                ),
                                onPressed: () {
                                  nombre = value[index].name;
                                  fecha = value[index].date;
                                  tiempoNotificacion =
                                      value[index].timeNotification;
                                  idCategoria =
                                      value[index].category.toString();
                                  print(fecha);

                                  categoriesController
                                      .getCategoriaSelected(idCategoria)
                                      .then((value) => {
                                            if (value == null)
                                              {
                                                categoria = "Ninguno",
                                              }
                                            else
                                              {categoria = value},
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => InfoEvent(
                                                            user: this.user,
                                                            nombre: this.nombre,
                                                            categoria:
                                                                this.categoria,
                                                            tiempoNotificacion:
                                                                this.tiempoNotificacion,
                                                            fecha: this.fecha,
                                                          )),
                                            )
                                          });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromRGBO(238, 211, 110, 0.7),
                                ),
                                onPressed: () {
                                  String id = value[index].id;
                                  nombre = value[index].name;
                                  fecha = value[index].date;
                                  tiempoNotificacion =
                                      value[index].timeNotification;
                                  idCategoria =
                                      value[index].category.toString();
                                  print(fecha);

                                  categoriesController
                                      .getCategoriaSelected(idCategoria)
                                      .then((value) => {
                                            if (value == null)
                                              {
                                                categoria = "Ninguno",
                                              }
                                            else
                                              {categoria = value},
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => EditEvent(
                                                            id: id,
                                                            user: this.user,
                                                            nombre: this.nombre,
                                                            categoria:
                                                                this.categoria,
                                                            tiempoNotificacion:
                                                                this.tiempoNotificacion,
                                                            fecha: this.fecha,
                                                          )),
                                            )
                                          });
                                },
                              ),
                            ])
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
