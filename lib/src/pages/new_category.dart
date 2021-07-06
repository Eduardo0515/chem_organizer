import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({Key? key}) : super(key: key);

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  final _formKey = GlobalKey<FormState>();
  bool _exist = false;
  TextEditingController _categoryController = TextEditingController();

  existCategory() async {
    categories
        .where('category', isEqualTo: _categoryController.text.toUpperCase())
        .get()
        .then((value) => {
              print(value.size),
              if (value.size > 0)
                {
                  Fluttertoast.showToast(
                      msg: 'Ese nombre ya esta registrado',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white),
                  _exist = true
                }
              else
                {_exist = false}
            })
        .catchError((error) => {
              Fluttertoast.showToast(
                  msg: 'Hubo un error al añadir la categoría',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red.shade300,
                  textColor: Colors.white),
              _exist = true
            })
        .then((value) => {
              if (!_exist) {addCategory()}
            });
  }

  addCategory() async {
    categories
        .add({'category': _categoryController.text.toUpperCase()})
        .whenComplete(() => {
              Fluttertoast.showToast(
                  msg: 'Nueva categoría Añadida',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green.shade400,
                  textColor: Colors.white),
            })
        .catchError((error) => {
              Fluttertoast.showToast(
                  msg: 'Hubo un error al añadir la categoría',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red.shade300,
                  textColor: Colors.white)
            })
        .then((value) => {Navigator.pop(context)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Categoría'),
      ),
      body: Container(
          padding: EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Nombre'),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    hintText: 'Categoría',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo vacío';
                    } else {
                      value = value
                          .replaceAll(RegExp(r'[\s]+'), ' ')
                          .replaceAll(RegExp(r'\s$'), '')
                          .replaceAll(RegExp(r'^\s'), '');
                      _categoryController.text = value;
                      if (value.length < 3) {
                        return 'Nombre inválido';
                      }
                    }
                    return null;
                  },
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      existCategory();
                    }
                  },
                  child: Text('Guardar'),
                )
              ],
            ),
          )),
    );
  }
}
