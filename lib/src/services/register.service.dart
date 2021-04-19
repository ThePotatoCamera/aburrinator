import 'package:aburrinator/src/pages/contador.page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class RegisterProcess extends StatefulWidget {

  final String mail;
  final String pass;

  RegisterProcess({Key key, @required this.mail, @required this.pass}) : super(key: key);

  @override
  _RegisterProcessState createState() => _RegisterProcessState();
}

class _RegisterProcessState extends State<RegisterProcess> {

  final _progreso = GetStorage("contador");

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
      final UserCredential newUser = await _auth.createUserWithEmailAndPassword(email: widget.mail, password: widget.pass);
      if (newUser != null) {
        print(newUser);
        User user = FirebaseAuth.instance.currentUser;

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Usuario creado con éxito, confirma tu registro en tu correo electrónico."),
                  duration: Duration(seconds: 2)
              )
          );
          await FirebaseAuth.instance.signOut();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Usuario creado con éxito."),
                  duration: Duration(seconds: 2)
              )
          );
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ContadorPage(_progreso.read("contrador"))),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print(e);
      if (e.code =="email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("El correo ya existe."),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
          content: Text("No se ha podido completar tu registro."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
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
