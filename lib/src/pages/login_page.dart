import 'package:chem_organizer/src/models/login.dart';
import 'package:chem_organizer/src/pages/calendar.dart';
import 'package:chem_organizer/src/pages/main_view.dart';
import 'package:chem_organizer/src/pages/register_page.dart';
import 'package:chem_organizer/src/services/authentication.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final userAuthentication = UserAuthentication();

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
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 40),
                    child: Icon(
                      Icons.person_pin,
                      size: 200.0,
                      color: Colors.deepPurpleAccent.shade200,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo requerido';
                        } else {
                          if (!RegExp(
                                  r'^[a-zA-Z0-9+_\.-]+@[a-zA-Z0-9-]+\.[a-z0-9]+')
                              .hasMatch(value)) {
                            return 'Ingrese un formato de correo válido';
                          }
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.deepPurpleAccent.shade100,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        labelText: 'Correo',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 40),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo requerido';
                        } else {
                          if (value.length < 8) {
                            return 'La contraseña debe contener al menos ocho elementos';
                          } else {
                            if (value.length > 30) {
                              return 'La contraseña no debe exceder de 30 elementos';
                            } else {
                              if (value.contains(' ')) {
                                return 'No se aceptan espacios';
                              } else {
                                if (!RegExp(
                                        r'(?=.*[a-zA-Z])(?=.*[!@$%&])(?=.*[0-9])')
                                    .hasMatch(value)) {
                                  if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])')
                                      .hasMatch(value)) {
                                    return 'Debe contener números y letras';
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
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.deepPurpleAccent.shade100,
                        ),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent.shade100,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          textStyle: TextStyle(color: Colors.white),
                          shadowColor: Colors.grey,
                        ),
                        child: Text('Iniciar sesión',
                            style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print("validacion exitosa");
                            userAuthentication
                                .login(emailController.text,
                                    passwordController.text)
                                .then((value) => {
                                      if (value.auth)
                                        {
                                          print("Correcto"),
                                          print(value.id),
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainView(user: value.id,)),
                                          )
                                        }
                                      else
                                        {_showAlertDialog()}
                                    });
                          }
                        },
                      )),
                  Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: <Widget>[
                          Text('¿No tienes una cuenta?',
                              style: TextStyle(fontSize: 14)),
                          GestureDetector(
                            child: Text(
                              '   Regístrate',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepPurpleAccent.shade100,
                              ),
                            ),
                            onTap: () {
                              print("Regístrate");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent.shade200,
                ),
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
