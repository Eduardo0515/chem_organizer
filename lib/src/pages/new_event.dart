import 'package:chem_organizer/src/models/categoryEvent.dart';
import 'package:chem_organizer/src/pages/edit_category.dart';
import 'package:chem_organizer/src/pages/main_view.dart';
import 'package:chem_organizer/src/pages/new_category.dart';
import 'package:chem_organizer/src/provider/categories_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  var _selectedCategory;
  int _selectedTimeNotification = 10;

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
    FirebaseFirestore.instance
        .collection('tarea')
        .add({
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
                MaterialPageRoute(builder: (context) => MainView()),
              )
            })
        .catchError((error) => {
              Fluttertoast.showToast(
                  msg: 'Hubo un error al añadir el evento',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red.shade300,
                  textColor: Colors.white)
            });
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
      appBar: AppBar(
        title: Text('Añadir Nuevo evento'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nombre del evento:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo vacío';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Evento',
                      ),
                      controller: nameController,
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
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child:
                                new Text("${_date.toLocal()}".split(' ')[0])),
                      ]),
                      Column(
                        children: [
                          Text(
                            'Hora:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              _selectTime();
                            },
                            child: new Text("${_time.format(context)}"),
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
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("categories")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Text("Loading.....");
                            else {
                              List<DropdownMenuItem<String>> items = [];
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                items.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      snap.get("category"),
                                    ),
                                    value: "${snap.id}",
                                  ),
                                );
                              }
                              var dropdownButton = DropdownButton(
                                items: items,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                value: _selectedCategory,
                                isExpanded: false,
                                hint: Text("Selecionar Categoria"),
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
                                    builder: (context) => NewCategory()),
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
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: DropdownButton<int>(
                      value: _selectedTimeNotification,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
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
                          elevation: 10.0,
                          shadowColor: Colors.blue,
                          primary: Colors.blue[400],
                          minimumSize: Size(120, 50),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
      ),
    );
  }

  _editButton(BuildContext context) {
    if (_selectedCategory != null && _selectedCategory != '0001') {
      return TextButton(
          child: Text("Editar"),
          onPressed: () {
            CategoriesController()
                .getCategory(_selectedCategory)
                .then((value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCategory(category: value),
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
}
