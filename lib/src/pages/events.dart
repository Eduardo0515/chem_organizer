import 'package:chem_organizer/src/models/categoryEvent.dart';
import 'package:chem_organizer/src/pages/edit_event.dart';
import 'package:chem_organizer/src/pages/info_event.dart';
import 'package:chem_organizer/src/provider/categories_controller.dart';
import 'package:chem_organizer/src/provider/events_controller.dart';
import 'package:chem_organizer/src/services/push_notifications_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events extends StatefulWidget {
  final String user;
  const Events({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _EventsState(this.user);
}

class _EventsState extends State<Events> {
  final String user;
  final eventsController = EventsController();
  Timestamp time = new Timestamp.fromDate(DateTime.now());
  String _selectedIdCategory = 'todos';

  late CategoriesController categoriesController;

  _EventsState(this.user);

  @override
  void initState() {
    categoriesController = new CategoriesController(this.user);
  }

  Stream<QuerySnapshot<Object?>> getQuery() {
    CollectionReference eventos = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(this.user)
        .collection('eventos');
    //devolver el tipo de consulta para la agrupacion por categorias
    if (_selectedIdCategory == 'todos')
      return eventos
          .where("fecha", isGreaterThanOrEqualTo: time)
          .orderBy("fecha")
          .limit(25)
          .snapshots();
    else
      return eventos
          .where('categoria', isEqualTo: _selectedIdCategory)
          .where("fecha", isGreaterThanOrEqualTo: time)
          .orderBy("fecha")
          .limit(25)
          .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    categoriesController.getCategory(_selectedIdCategory).then((value) => {
          if (value != null) {_selectedIdCategory = 'todos'}
        });
    eventsController.getEvents(this.user);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(133, 45, 145, 1.0),
          Color.fromRGBO(49, 42, 108, 1.0),
        ],
      )),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Text(
          "Agrupar por:",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        Container(
          height: 50,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(this.user)
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else {
                  List<DropdownMenuItem<String>> items = [];
                  items.add(DropdownMenuItem(
                    child: Text(
                      'TODOS',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'todos',
                  ));
                  items.add(DropdownMenuItem(
                    child: Text(
                      'NINGUNO',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: '0001',
                  ));
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    DocumentSnapshot snap = snapshot.data!.docs[i];
                    items.add(
                      DropdownMenuItem(
                        child: Text(
                          snap.get("category"),
                          style: TextStyle(color: Colors.white),
                        ),
                        value: "${snap.id}",
                      ),
                    );
                  }
                  var dropdownButton = DropdownButton(
                    icon: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.white,
                    ),
                    items: items,
                    dropdownColor: Color.fromRGBO(133, 45, 145, 1.0),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedIdCategory = newValue.toString();
                      });
                    },
                    value: _selectedIdCategory,
                    isExpanded: false,
                    hint: Text("Selecionar Categoria",
                        style: TextStyle(color: Colors.white60)),
                  );
                  return dropdownButton;
                }
              }),
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: getQuery(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Hubo un error con la conexión',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
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
                    color: Colors.white30,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else
              return ListView(
                children: snapshot.data!.docs.map(
                  (doc) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          int idNotification = doc.get('id');
                          eventsController
                              .deleteEvent(doc.id, this.user)
                              .then((value) => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Evento eliminado'))),
                                    notificationsPlugin.cancel(idNotification),
                                    notificationsPlugin
                                        .cancel(idNotification - 100000000),
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
                          color: Color.fromRGBO(252, 12, 12, 0.3),
                          child: Icon(
                            Icons.delete,
                            size: 35.0,
                            color: Colors.white,
                          )),
                      child: Card(
                        child: Row(children: [
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
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.all(15.0),
                            child: buildCategoria(doc.get('categoria')),
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: Color.fromRGBO(238, 211, 110, 0.7),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InfoEvent(
                                              user: this.user,
                                            )),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromRGBO(238, 211, 110, 0.7),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEvent(
                                              user: this.user,
                                            )),
                                  );
                                },
                              )
                            ],
                          )
                        ]),
                      ),
                    );
                  },
                ).toList(),
              );
          },
        )),
      ]),
    );
  }

  buildCategoria(String idCategoria) {
    if (idCategoria == '0001') {
      return Text(
        'NINGUNO',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return StreamBuilder<CategoryEvent?>(
          stream: categoriesController.getCategory(idCategoria).asStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            } else {
              return Text(
                snapshot.data!.category,
                style: TextStyle(color: Colors.white),
              );
            }
          });
    }
  }
}
