import 'package:chem_organizer/src/models/categoryEvent.dart';
import 'package:chem_organizer/src/pages/edit_category.dart';
import 'package:chem_organizer/src/pages/main_view.dart';
import 'package:chem_organizer/src/pages/new_category.dart';
import 'package:chem_organizer/src/provider/categories_controller.dart';
import 'package:chem_organizer/src/services/push_notifications_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;

class NewEvent extends StatefulWidget {
  final String user;
  const NewEvent({Key? key, required this.user}) : super(key: key);

  @override
  _NewEventState createState() => _NewEventState(this.user);
}

class _NewEventState extends State<NewEvent> {
  final String user;
  final _formKey = GlobalKey<FormState>();

  late CategoriesController categoriesController;

  TextEditingController nameController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  var _selectedCategory = '0001';
  int _selectedTimeNotification = 10;
  dynamic data;

  _NewEventState(this.user);

  @override
  void initState() {
    categoriesController = new CategoriesController(this.user);
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Selecione la fecha',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  addEvent() {
    DateTime fecha = new DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
        int id = Timestamp.now().millisecondsSinceEpoch;
    data = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(this.user)
        .collection('eventos')
        .add({
          'id': id,
          'nombre': nameController.text,
          'fecha': fecha,
          'categoria': _selectedCategory,
          'tiempoNotificacion': _selectedTimeNotification
        })
        .then((value) => {
              Fluttertoast.showToast(
                  msg: 'Nuevo Evento Añadido',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green.shade400,
                  textColor: Colors.white),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainView(
                          user: this.user,
                        )),
              ),
              print("SOY DATAAAAAA" + value.id),
              //Mostrar notificacion
              displayNotification(
                  id, nameController.text, "Tienes una tarea pendiente", fecha)
            })
        .catchError(
          (error) => {
            Fluttertoast.showToast(
                msg: 'Hubo un error al añadir el evento',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red.shade300,
                textColor: Colors.white)
          },
        );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Seleccione alguna categoría',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(49, 42, 108, 1.0),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Añadir Nuevo evento',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(133, 45, 145, 1.0),
              Color.fromRGBO(49, 42, 108, 1.0),
            ],
          )),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Nombre del evento:',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo vacío';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Evento',
                          hintStyle: TextStyle(color: Colors.white60),
                        ),
                        controller: nameController,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Text(
                            'Fecha:',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          TextButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: new Text(
                                "${_date.toLocal()}".split(' ')[0],
                                style: Theme.of(context).textTheme.bodyText1,
                              )),
                        ]),
                        Column(
                          children: [
                            Text(
                              'Hora:',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            TextButton(
                              onPressed: () {
                                _selectTime();
                              },
                              child: new Text(
                                "${_time.format(context)}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Categoria:',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("usuarios")
                                .doc(this.user)
                                .collection('categories')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Text("Loading.....");
                              else {
                                List<DropdownMenuItem<String>> items = [];
                                items.add(DropdownMenuItem(
                                  child: Text(
                                    'NINGUNO',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  value: "0001",
                                ));
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
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
                                  items: items,
                                  dropdownColor:
                                      Color.fromRGBO(133, 45, 145, 1.0),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedCategory = newValue.toString();
                                    });
                                  },
                                  value: _selectedCategory,
                                  isExpanded: false,
                                  hint: Text("Selecionar Categoria",
                                      style: TextStyle(color: Colors.white60)),
                                );
                                return dropdownButton;
                              }
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            _editButton(context),
                            TextButton(
                              child: Text("Añadir otra"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewCategory(
                                            user: this.user,
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Notificar minutos antes:',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Center(
                      child: DropdownButton<int>(
                        value: _selectedTimeNotification,
                        icon: const Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        iconSize: 20,
                        elevation: 5,
                        dropdownColor: Color.fromRGBO(133, 45, 145, 1.0),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedTimeNotification = newValue!;
                          });
                        },
                        items: <int>[5, 10, 15, 20]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            primary: Colors.pink.shade400,
                            minimumSize: Size(120, 50),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("validacion exitosa");
                              if (_selectedCategory == null) {
                                showToast();
                              } else {
                                addEvent();
                              }
                            }
                          },
                          child: Text(
                            'Añadir Evento',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  _editButton(BuildContext context) {
    if (_selectedCategory != null && _selectedCategory != '0001') {
      return TextButton(
          child: Text("Editar"),
          onPressed: () {
            categoriesController
                .getCategory(_selectedCategory)
                .then((value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCategory(
                            category: value,
                            user: this.user,
                          ),
                        ),
                      )
                    });
          });
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }

  Future<void> displayNotification(
      int id, String title, String body, DateTime dateTime) async {
    notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails(
                'channelId', 'channelName', 'channelDescription')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
