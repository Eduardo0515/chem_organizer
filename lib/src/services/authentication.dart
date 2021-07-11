import 'package:chem_organizer/src/models/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthentication {
  final _authFirebase = FirebaseAuth.instance;
  Future<Login> register(String email, String password) async {
    String id = "";
    String message = "";
    bool auth = false;

    try {
      UserCredential userCredential = await _authFirebase
          .createUserWithEmailAndPassword(email: email, password: password);
      id = userCredential.user!.uid;
      auth = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        message = "La contraseña es muy débil";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        message = "Ya existe una cuenta para este correo";
      } else if (e.code == 'invalid-email') {
        print('Invalid email');
        message = "El correo ingresado no es válido";
      }
    } catch (e) {
      print(e);
    }
    return Login(auth: auth, id: id, message: message);
  }

  Future<Login> login(String email, String password) async {
    String id = "";
    String message = "";
    bool auth = false;

    try {
      UserCredential userCredential = await _authFirebase
          .signInWithEmailAndPassword(email: email, password: password);
      id = userCredential.user!.uid;
      auth = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        message = "Por favor, verifique los datos ingresados";
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        message = "Por favor, verifique los datos ingresados";
      }
    }
    return Login(auth: auth, id: id, message: message);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
