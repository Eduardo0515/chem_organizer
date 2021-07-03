import 'package:chem_organizer/src/custom_view/curved_painter.dart';
import 'package:chem_organizer/src/provider/events_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EventsState();
}

class _EventsState extends State<Events> {
  final eventsController = EventsController();
  @override
  Widget build(BuildContext context) {
    eventsController.getEvents();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tarea').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      eventsController.deleteEvent(doc.id).then((value) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Evento eliminado')))
                          });
                    });
                  },
                  background: Container(color: Colors.teal[100]),
                  child: Card(
                      color: Colors.blue[300],
                      shadowColor: Colors.orange[300],
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      elevation: 15.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0))),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(doc.get("nombre"),
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text(
                                  eventsController.getDate(doc.get("fecha")),
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: Text("Categoria", style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      )),
                );
              }).toList(),
            );
        },
      ),
    );
  }
}
