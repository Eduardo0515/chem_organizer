<<<<<<< HEAD
import 'package:chem_organizer/src/models/categoryEvent.dart';
=======
import 'package:chem_organizer/src/pages/edit_event.dart';
import 'package:chem_organizer/src/pages/info_event.dart';
>>>>>>> main
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
  String _selectedIdCategory = 'todos';

  CollectionReference categories = FirebaseFirestore.instance
      .collection("usuarios")
      .doc('hugo')
      .collection('categories');

  Stream<QuerySnapshot<Object?>> getQuery() {
    CollectionReference eventos = FirebaseFirestore.instance
        .collection('usuarios')
        .doc('hugo')
        .collection('eventos');

    if (_selectedIdCategory == 'todos')
      return eventos
          .where("fecha", isGreaterThanOrEqualTo: time)
          .orderBy("fecha")
          .limit(25)
          .snapshots();
    else
      return eventos
          .where("fecha", isGreaterThanOrEqualTo: time)
          .where('categoria', isEqualTo: _selectedIdCategory)
          .orderBy("fecha")
          .limit(25)
          .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    eventsController.getEvents();
    print("------------------recragr$_selectedIdCategory");
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Text(
          "      Agrupar por:",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Container(
            height: 50,
            child: StreamBuilder<QuerySnapshot>(
              stream: categories.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs.map((doc) {
                            return Row(
                              children: [
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    primary: Colors.pink.shade400,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  child: Text(
                                    doc.get('category'),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    _selectedIdCategory = doc.id;
                                    print(_selectedIdCategory);
                                  },
                                ),
                                SizedBox(width: 5)
                              ],
                            );
                          }).toList()));
                }
              },
            )),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getQuery(),
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
                                  content: Text(
                                      "¿Está seguro de eliminar el evento?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text("Cancelar")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text("Aceptar")),
                                  ],
                                ));
                      },
                      background: Container(
                          color: Colors.teal[100],
                          child: Icon(
                            Icons.delete,
                            size: 35.0,
                          )),
                      child: Card(
                          child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(30, 0, 10, 3),
                              title: Text(doc.get("nombre"),
                                  style: Theme.of(context).textTheme.bodyText1),
                              subtitle: Text(
                                  eventsController.getDate(doc.get("fecha")),
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.7,
                                  )),
<<<<<<< HEAD
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: categories
                                    .doc(doc.get('categoria'))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.amber,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data!.get('category'),
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }
                                }),
                          )
                        ],
                      )),
                    );
                  }).toList(),
=======
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoEvent(
                                )),
                              );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEvent(
                                )),
                              );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Categoria",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    
                    ],
                  )
                ),
>>>>>>> main
                );
            },
          ),
        ),
      ]),
    );
  }
}
