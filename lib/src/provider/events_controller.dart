import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventsController {
  CollectionReference tareas = FirebaseFirestore.instance.collection('tarea');

  getDate(Timestamp time) {
    DateTime fecha = time.toDate();
    print(fecha);
    String formattedDate = DateFormat('yyyy-MM-dd – h:mma').format(fecha);
    return formattedDate;
    //return "Fecha:${fecha.year}-${fecha.month}-${fecha.day}  Hora: ${fecha.hour}: ${fecha.minute}";
  }

  Future<void> deleteEvent(String id) {
    return tareas
        .doc(id)
        .delete()
        .then((value) => print("Event Deleted"))
        .catchError((error) => print("Failed to delete event: $error"));
  }
}
