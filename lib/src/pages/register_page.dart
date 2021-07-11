import 'package:chem_organizer/src/pages/login_page.dart';
import 'package:chem_organizer/src/pages/main_view.dart';
import 'package:chem_organizer/src/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final userAuthentication = UserAuthentication();

  final formKey = GlobalKey<FormState>();

  bool hidePassword = true;
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
                        padding: EdgeInsets.fromLTRB(60, 5, 60, 30),
                        child: Icon(
                          Icons.app_registration_rounded,
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
                        padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                        child: Column(
                          children: [
                            TextFormField(
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
                                          if (!RegExp(
                                                  r'(?=.*[a-zA-Z])(?=.*[0-9])')
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
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  icon: Icon(hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          height: 50,
                          width: 310,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurpleAccent.shade100,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
                              textStyle: TextStyle(color: Colors.white),
                              shadowColor: Colors.deepPurpleAccent.shade100,
                            ),
                            child: Text('Registrarse',
                                style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                print("validacion exitosa");
                                userAuthentication
                                    .register(emailController.text,
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
                                                        MainView(
                                                          user: value.id,
                                                        )),
                                              )
                                            }
                                          else
                                            {
                                              print("Incorrecto"),
                                              _showAlertDialog(value.message)
                                            }
                                        });
                              }
                            },
                          )),
                      Container(
                          padding: EdgeInsets.all(30),
                          child: Row(
                            children: <Widget>[
                              Text('¿Ya tienes una cuenta?',
                                  style: TextStyle(fontSize: 14)),
                              GestureDetector(
                                child: Text(
                                  '   Inicia sesión',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.deepPurpleAccent.shade100,
                                  ),
                                ),
                                onTap: () {
                                  print("Inicia sesión");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ))
                    ],
                  ))),
        ),
      )),
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("ERROR"),
            content: Text(message),
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
