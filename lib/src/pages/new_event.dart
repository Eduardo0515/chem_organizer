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
      initialDate: _date, // Refer step 1
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

  addUser() {
    DateTime fecha = new DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    FirebaseFirestore.instance
        .collection('tarea')
        .add({
          'nombre': nameController.text,
          'fecha': fecha,
          'categoria': _selectedCategory
        })
        .then((value) => {
              Fluttertoast.showToast(
                  msg: 'Nuevo Evento Añadido',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green.shade400,
                  textColor: Colors.white)
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
          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nombre del evento:'),
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
                    height: 75,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        Text('Fecha:'),
                        TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child:
                                new Text("${_date.toLocal()}".split(' ')[0])),
                      ]),
                      Column(
                        children: [
                          Text('Hora:'),
                          TextButton(
                              onPressed: () {
                                _selectTime();
                              },
                              child: new Text("${_time.hour}:${_time.minute}")),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Text('Categoria:'),
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
                              return DropdownButton(
                                items: items,
                                onChanged: (newValue) {
                                  //print("----------------${currencyValue}");
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                value: _selectedCategory,
                                isExpanded: false,
                                hint: Text("Selecionar Categoria"),
                              );
                            }
                          }),
                      TextButton(
                        onPressed: () {},
                        child: Text("Añadir otra"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.blue,
                            backgroundColor: Colors.amber.shade100,
                            padding: EdgeInsets.all(20)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print("validacion exitosa");
                            if (_selectedCategory == null) {
                              showToast();
                            } else {
                              addUser();
                            }
                          }
                        }, //addUser,
                        child: Text('Añadir Evento'),
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
}
