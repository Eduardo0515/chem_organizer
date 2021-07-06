import 'package:chem_organizer/src/pages/new_event.dart';
import 'package:chem_organizer/src/provider/categories_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditCategory extends StatelessWidget {
  final category;

  const EditCategory({Key? key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
                  CategoriesController().deleteCategory(category.id);
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
        title: Text('Editar Categoría'),
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
                      value = CategoriesController().checkName(value);
                      _categoryController.text = value;
                      if (value.length < 3) {
                        return 'Nombre inválido';
                      }
                    }
                    return null;
                  },
                ),
                Row(children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _showDialogAlert().whenComplete(() => {
                            Navigator.pop(context),
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewEvent()),
                            )
                          });
                    },
                    child: Text('Eliminar'),
                  ),
                  TextButton(
                    onPressed: () {
                      CategoriesController()
                          .updateCategory(category.id, _categoryController.text)
                          .then((value) => {
                                Navigator.pop(
                                  context,
                                )
                              });
                    },
                    child: Text('Actualizar'),
                  ),
                ]),
              ],
            ),
          )),
    );
  }
}
