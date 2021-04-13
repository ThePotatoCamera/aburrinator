import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'contador_page.dart';

class LoginProcess extends StatefulWidget {


  final String mail;
  final String pass;

  LoginProcess({Key key, @required this.mail, @required this.pass}) : super(key: key);

  @override
  _LoginProcessState createState() => _LoginProcessState();
}

class _LoginProcessState extends State<LoginProcess> {

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Sesión iniciada con éxito"),
              duration: Duration(seconds: 2)
          )
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ContadorPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
