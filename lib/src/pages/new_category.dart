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
      FirebaseFirestore.instance.collection('usuarios').doc('hugo').collection('categories');

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
        toolbarHeight: 80,
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
        title: Text('Nueva Categoría',
            style: Theme.of(context).textTheme.headline2),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(133, 45, 145, 1.0),
              Color.fromRGBO(49, 42, 108, 1.0),
            ],
          )),
          padding: EdgeInsets.all(50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Nombre',
                  style: Theme.of(context).textTheme.headline3,
                ),
                TextFormField(
                  controller: _categoryController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Categoría',
                    hintStyle: TextStyle(color: Colors.white60),
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
                SizedBox(
                  height: 50,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.pink.shade400,
                    minimumSize: Size(120, 50),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      existCategory();
                    }
                  },
                  child: Text('Guardar', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          )),
    );
  }
}
