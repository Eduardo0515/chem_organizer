import 'package:chem_organizer/src/pages/calendar.dart';
import 'package:chem_organizer/src/pages/events.dart';
import 'package:chem_organizer/src/pages/new_event.dart';
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
          toolbarHeight: 125,
          title: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Chem Organizer",
                style: Theme.of(context).textTheme.headline1,
              )),
          bottom: TabBar(
            indicatorColor: Colors.purple.shade300,
            labelColor: Colors.amber.shade300,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 13),
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(
                text: "Calendario",
              ),
              Tab(
                text: "Eventos",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [CalendarPage(), Events()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("object");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewEvent()),
            );
          },
          child: const Icon(Icons.add_task_rounded),
          backgroundColor: Colors.amber.shade700,
        ),
      ),
    );
  }
}
