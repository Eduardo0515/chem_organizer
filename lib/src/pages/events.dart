import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EventsState();
}

DateTime _dateNow = DateTime.now();

getDate(Timestamp time) {
  DateTime fecha = time.toDate();
  print(fecha);
  String formattedDate = DateFormat('yyyy-MM-dd – h:mma').format(fecha);
  return formattedDate;
  //return "Fecha:${fecha.year}-${fecha.month}-${fecha.day}  Hora: ${fecha.hour}: ${fecha.minute}";
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tarea')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: ListTile(
                    title: Text(doc.get("nombre")),
                    subtitle: Text(getDate(doc.get("fecha"))),
                  ),
                );
              }).toList(),
            );
        },
      ),
    );
  }
}
