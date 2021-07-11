import 'package:chem_organizer/src/pages/new_event.dart';
import 'package:chem_organizer/src/provider/categories_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditCategory extends StatelessWidget {
  final category;
  final String user;
  const EditCategory({Key? key, @required this.category, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    CategoriesController categoriesController =
        new CategoriesController(this.user);

    TextEditingController _categoryController = TextEditingController();
    _categoryController.text = category.category;

    Future<void> _showDialogAlert() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eliminar Categoria'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('¿Está seguro de eliminar esta categoria?'),
                  Text(
                      'Los eventos relacionados con esta catgeoría quedaran por default'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.pop(context);
                  categoriesController.deleteCategory(category.id);
                },
              ),
              TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        },
      );
    }

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
        title: Text(
          'Editar Categoría',
          style: Theme.of(context).textTheme.headline2,
        ),
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
                      value = categoriesController.checkName(value);
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          _showDialogAlert().whenComplete(() => {
                                Navigator.pop(context),
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewEvent(
                                            user: this.user,
                                          )),
                                )
                              });
                        },
                        child: Text(
                          'Eliminar',
                          style: TextStyle(
                            color: Colors.pink.shade200,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          categoriesController
                              .updateCategory(
                                  category.id, _categoryController.text)
                              .then((value) => {
                                    Navigator.pop(
                                      context,
                                    )
                                  });
                        },
                        child: Text(
                          'Actualizar',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          )),
    );
  }
}
