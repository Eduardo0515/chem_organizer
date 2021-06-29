import 'package:flutter/material.dart';

class NewToDo extends StatelessWidget {
  const NewToDo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Nuevo evento'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
          child: Container(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nombre del evento:'),
                  Container(
                    child: TextFormField(
                        decoration: InputDecoration(
                      hintText: 'Evento',
                    )),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text('Hora:'),
                  SizedBox(
                    height: 100,
                  ),
                  Text('Categoria:'),
                  Container(
                    child: TextFormField(
                        decoration: InputDecoration(
                      hintText: 'Evento',
                    )),
                  ),
                  SizedBox(
                    height: 100,
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
