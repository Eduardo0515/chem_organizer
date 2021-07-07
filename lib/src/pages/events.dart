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
  Timestamp time = new Timestamp.fromDate(DateTime.now());
  @override
  Widget build(BuildContext context) {
    eventsController.getEvents();
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
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tarea')
            .where("fecha", isGreaterThanOrEqualTo: time)
            .orderBy("fecha")
            .limit(25)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Sin eventos próximos',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  confirmDismiss: (_) {
                    return showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Eliminar evento"),
                              content:
                                  Text("¿Está seguro de eliminar el evento?"),
                              actions: [
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(false);
                                }, child: Text("Cancelar")),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop(true);
                                }, child: Text("Aceptar")),
                              ],
                            ));
                  },
                  background: Container(color: Colors.teal[100], child: Icon(Icons.delete, size:35.0,)),
                  child: Card(
                      child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 10, 3),
                          title: Text(doc.get("nombre"),
                              style: Theme.of(context).textTheme.bodyText1),
                          subtitle:
                              Text(eventsController.getDate(doc.get("fecha")),
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.7,
                                  )),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Categoria",
                          style: TextStyle(color: Colors.white),
                        ),
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
