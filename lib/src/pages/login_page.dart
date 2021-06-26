
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(60, 100, 60, 40),
                    child: Image.asset("assets/iconoLogin.png",
                        width: 170, height: 170),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo vacío';
                        } else {
                          if (value.length < 8) {
                            return 'El usuario debe tener al menos 8 caracteres';
                          } else {
                            if (value.length > 30) {
                              return 'El usuario debe tener 30 caracteres como maximo';
                            } else {
                              if (RegExp(r'^[\da-zA-Z]+$').hasMatch(value)) {
                                if (!RegExp(r'[a-zA-Z]+').hasMatch(value)) {
                                  return "El usuario debe contener al menos una letra";
                                }
                              } else {
                                return "El usuario debe ser alfanumerico";
                              }
                            }
                          }
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Usuario',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo vacío';
                        } else {
                          if (value.length < 8) {
                            return 'Contraseña muy corta';
                          } else {
                            if (value.length > 30) {
                              return 'Tamaño de contraseña inválida';
                            } else {
                              if (value.contains(' ')) {
                                return 'No se acepta espacios';
                              } else {
                                if (!RegExp(
                                        r'(?=.*[a-zA-Z])(?=.*[!@$%&])(?=.*[0-9])')
                                    .hasMatch(value)) {
                                  if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])')
                                      .hasMatch(value)) {
                                    return 'Dede ser alfanumérica';
                                  }
                                  if (!RegExp(r'(?=.*[!@$%&])')
                                      .hasMatch(value)) {
                                    return 'use al menos un @!\$%&';
                                  }
                                }
                              }
                            }
                          }
                        }
                        return null;
                      },
                      obscureText: hidePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          color: Theme.of(context).accentColor.withOpacity(0.9),
                          icon: Icon(hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  
                  Container(
                      height: 50,
                      width: 310,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        textColor: Colors.white,
                        color: Color.fromRGBO(0, 176, 70, 69),
                        child: Text('Iniciar sesión',
                            style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          //print(nameController.text);
                          //print(passwordController.text);
                          if (formKey.currentState!.validate()) {
                            print("validacion exitosa");
                          }
                        },
                      )),
                  Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: <Widget>[
                          Text('¿No tienes una cuenta?',
                              style: TextStyle(fontSize: 14)),
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              'Registrate',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              print("Regístrate");
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("ERROR"),
            content: Text("El usuario o contraseña son incorrectos"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "CERRAR",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
