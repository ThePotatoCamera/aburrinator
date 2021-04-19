import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../pages/contador.page.dart';

class LoginProcess extends StatefulWidget {

  final String mail;
  final String pass;

  LoginProcess({Key key, @required this.mail, @required this.pass}) : super(key: key);

  @override
  _LoginProcessState createState() => _LoginProcessState();
}

class _LoginProcessState extends State<LoginProcess> {

  final progreso = GetStorage("contador");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      signin();
    });
  }
  void signin() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final loginUser = await _auth.signInWithEmailAndPassword(email: widget.mail, password: widget.pass);
      if (loginUser != null) {
        User currentUser = FirebaseAuth.instance.currentUser;
        if (!currentUser.emailVerified) {
          await currentUser.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Debes confirmar tu correo electrónico."),
                  duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              )
          );
          Navigator.pop(context);
          return;
        }
        print(loginUser);
        await _loadFirebaseData(loginUser.user.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Sesión iniciada con éxito"),
              duration: Duration(seconds: 2)
          )
        );
        final _progreso = GetStorage("contador");
        FirebaseFirestore.instance.collection("usuarios")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get()
            .then((DocumentSnapshot value) async {
              if (value.exists) {
                var data = value.data();
                if (_progreso.read("contador") < data["contador"] || _progreso.read("contador") == null) {
                  await _progreso.write("contador", data["contador"]);
                }
              } else {
                print("Error al leer los datos desde Firebase, el documento no existe");
              }
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ContadorPage(_progreso.read("contador"))),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print(e);
      if (e.code == "user-disabled") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("La cuenta ha sido deshabilitada."),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            )
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("El correo o la contraseña no coinciden."),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            )
        );
      }
      Navigator.pop(context);
    }
  }

  _loadFirebaseData(loginUser) async {
    CollectionReference usuarios = FirebaseFirestore.instance.collection("usuarios");

    if (usuarios.doc(progreso.read("uuid")) == null) {
      Map<String, dynamic> localData = {
        "contador": progreso.read("contador"),
      };
      return usuarios
          .doc(loginUser)
          .set(localData)
          .then((value) => print("Se han creado los datos del usuario en $loginUser"));
    }
    else {
      await readData(loginUser);
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> readData(loginUser) async {
    FirebaseFirestore.instance.collection("usuarios")
        .doc(loginUser)
        .get()
        .then((DocumentSnapshot value) {
          if (value.exists) {
            var data = value.data();
            if (progreso.read("contador") < data["contador"] || progreso.read("contador") == null) {
              progreso.write("contador", data["contador"]);
            }
            else {}
          } else {
            print("Error al leer los datos desde Firebase, el documento no existe");
          }
    });
  }
}
