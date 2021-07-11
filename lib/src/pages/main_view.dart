import 'package:chem_organizer/src/pages/calendar.dart';
import 'package:chem_organizer/src/pages/events.dart';
import 'package:chem_organizer/src/pages/login_page.dart';
import 'package:chem_organizer/src/pages/new_event.dart';
import 'package:chem_organizer/src/services/authentication.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  final String user;
  const MainView({Key? key, required this.user});

  @override
  State<MainView> createState() => new _MainViewState(this.user);
}

class _MainViewState extends State<MainView> {
  final String user;
  final userAuthentication = UserAuthentication();

  _MainViewState(this.user);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          actions: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                child: IconButton(
                  icon: Icon(Icons.logout),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () {
                    userAuthentication
                        .logout()
                        .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            ));
                  },
                ))
          ],
        ),
        body: TabBarView(children: [
          CalendarPage(
            user: this.user,
          ),
          Events(
            user: this.user,
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("object");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewEvent(
                        user: this.user,
                      )),
            );
          },
          child: const Icon(Icons.add_task_rounded),
          backgroundColor: Colors.amber.shade700,
        ),
      ),
    );
  }
}
