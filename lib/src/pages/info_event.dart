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

class InfoEvent extends StatefulWidget {
  final String user;
  final String nombre;
  final String categoria;
  final int tiempoNotificacion;
  final String fecha;
  final String hora;
  const InfoEvent({Key? key, required this.user, required this.nombre, required this.categoria, required this.tiempoNotificacion, required this.fecha, required this.hora}) : super(key: key);

  @override
  _InfoEventState createState() => _InfoEventState(this.user);
}

class _InfoEventState extends State<InfoEvent> {
  final String user;
  final _formKey = GlobalKey<FormState>();

  _InfoEventState(this.user);

  @override
  void initState() {
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
            'Información del evento',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          //padding: EdgeInsets.all(25),
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
                      ' ',
                    ),
                    Text(
                      'Nombre del evento:',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      " "
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        widget.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Colors.white, 
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
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
                            'Fecha     Hora:',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            " "
                          ),
                          Text(
                                widget.fecha,
                                style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ]),
                        
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Categoria:',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      ' ',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.categoria,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Colors.white, 
                          fontSize: 15,
                        ),
                        ),
                        SizedBox(
                          width: 10,
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
                    Text(
                      " "
                    ),
                    Center(
                      child: Text(
                          widget.tiempoNotificacion.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Colors.white, 
                          fontSize: 15,
                        ),
                        
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  
}
