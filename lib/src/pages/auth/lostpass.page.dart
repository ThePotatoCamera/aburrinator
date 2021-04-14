import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.page.dart';

class PassOlvidada extends StatefulWidget {

  @override
  _PassOlvidadaState createState() => _PassOlvidadaState();
}

class _PassOlvidadaState extends State<PassOlvidada> {

  TextEditingController _mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contraseña olvidada"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _mail(),
          _resetPassButton()
        ],
      ),
    );
  }

  Widget _mail() {
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

  Widget _resetPassButton() {
    return OutlinedButton(
        onPressed: () async {
          String _mailText = _mailController.text;

          try {
            await FirebaseAuth.instance.sendPasswordResetEmail(email: _mailText);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Se ha enviado un correo para cambiar la contraseña."),
                    duration: Duration(seconds: 2)
                )
            );
          } catch (e) {
            print (e);
            if (e.code == "user-not-found") {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Se ha enviado un correo para cambiar la contraseña."),
                    duration: Duration(seconds: 2),
                  )
              );
            } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Error al procesar la solicitud."),
                    duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                )
            );
          }
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text("Restablecer contraseña")
    );
  }
}
