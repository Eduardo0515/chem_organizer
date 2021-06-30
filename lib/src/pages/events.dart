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
                  background: Container(color: Colors.blue),
                  child: Card(
                    child: ListTile(
                      title: Text(doc.get("nombre")),
                      subtitle: Text(eventsController.getDate(doc.get("fecha"))),
                    ),
                  ),
                );
              }).toList(),
            );
        },
      ),
    );
  }
}
