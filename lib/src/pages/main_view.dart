import 'package:chem_organizer/src/pages/calendar.dart';
import 'package:chem_organizer/src/pages/events.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => new _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Principal"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Calendario",
              ),
              Tab(
                text: "Tareas",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [CalendarPage(), Events()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: const Icon(Icons.add_box),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
