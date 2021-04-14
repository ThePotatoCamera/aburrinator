import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import 'account.page.dart';

class ConfirmPage extends StatefulWidget {

  final String currentUser;

  ConfirmPage({Key key, this.currentUser}) : super(key: key);

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  final String _currentMail = FirebaseAuth.instance.currentUser.email.toString();
  TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  void checkAuth() async {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        return;
      } else {
        print(user);
        Navigator.push(context, MaterialPageRoute(builder: (context) => AccountAdmin()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicia sesión para continuar"),
      ),
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _loginEmail(),
                _loginPass(),
                Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loginButton(),
                          ],
                        ),
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginEmail() {
    return TextFormField(
      initialValue: _currentMail,
      enabled: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "Correo electrónico",
          icon: Icon(Icons.email)
      ),
      validator: (String value) {
        if (value == null || value.isEmpty) {
          return "Introduce un correo electrónico.";
        }
        if (!EmailValidator.validate(value)) {
          return "Introduce un correo electrónico válido.";
        }
        return null;
      },
    );
  }

  Widget _loginPass() {
    return TextFormField(
      controller: _passController,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          labelText: "Contraseña",
          icon: Icon(Icons.lock)
      ),
      validator: (String input) {
        if (input == null || input.isEmpty) return "Introduce una contraseña.";
        if (input.length < 6) return "La contaseña debe tener 6 carácteres.";
        return null;
      },
    );
  }

  Widget _loginButton() {
    return OutlinedButton(
        child: Text("Confirmar acción"),
        onPressed: () async {
          String _passText = _passController.text;

          if (_formKey.currentState.validate()) {
            var _key = utf8.encode(_currentMail);
            var _bytes = utf8.encode(_passText);

            var _hmac = Hmac(sha512, _key);
            var _passDigest = _hmac.convert(_bytes);
            print(_currentMail);
            print(_passDigest.toString());

            EmailAuthCredential credential = EmailAuthProvider.credential(email: _currentMail, password: _passDigest.toString());

            FocusScope.of(context).requestFocus(new FocusNode());

            try {
              await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Se ha confirmado la acción."),
                  duration: Duration(seconds: 2),
                )
              );
              Navigator.pop(context, true);
            } catch (e) {
              print(e);
              if (e.code == "wrong-password") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("La contraseña es incorrecta."),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  )
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Ha ocurrido un error al confirmar la acción."),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  )
                );
                Navigator.pop(context);
              }
            }
          }
        });
  }
}
