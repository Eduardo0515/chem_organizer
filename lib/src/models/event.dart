import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final Timestamp date;
  final String category;

  Event(this.id, this.name, this.date, this.category);
}
