import 'dart:convert';

import 'package:aburrinator/src/services/login.service.dart';
import 'package:aburrinator/src/services/register.service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import '../account.page.dart';

class LoginPage extends StatefulWidget {

  final String currentUser;

  LoginPage({Key key, this.currentUser}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _mailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void checkAuth() async {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        return;
      } else {
        print(user);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountAdmin()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guardado en la nube"),
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
                            _registerButton()
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
      controller: _mailController,
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
        child: Text("Iniciar sesión"),
        onPressed: () {
          String _mailText = _mailController.text;
          String _passText = _passController.text;

          if (_formKey.currentState.validate()) {
            var _key = utf8.encode(_mailText);
            var _bytes = utf8.encode(_passText);

            var _hmac = Hmac(sha512, _key);
            var _passDigest = _hmac.convert(_bytes);
            print(_mailText);
            print(_passDigest.toString());
            Navigator.push(context, MaterialPageRoute(builder: (builder) =>
                LoginProcess(mail: _mailText, pass: _passDigest.toString(),)));
          }
        });
  }

  Widget _registerButton() {
    return OutlinedButton(
        child: Text("Registrarse"),
        onPressed: () {
          String _mailText = _mailController.text;
          String _passText = _passController.text;

          if (_formKey.currentState.validate()) {
            var _key = utf8.encode(_mailText);
            var _bytes = utf8.encode(_passText);

            var _hmac = Hmac(sha512, _key);
            var _passDigest = _hmac.convert(_bytes);
            print(_mailText);
            print(_passDigest.toString());
            Navigator.push(context, MaterialPageRoute(builder: (builder) =>
                RegisterProcess(
                  mail: _mailText, pass: _passDigest.toString(),)));
          }
        }
    );
  }
}