import 'dart:ui';

import 'package:aburrinator/src/pages/confirm.login.dart';
import 'package:aburrinator/src/pages/contador.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AccountAdmin extends StatefulWidget {
  @override
  _AccountAdminState createState() => _AccountAdminState();
}

class _AccountAdminState extends State<AccountAdmin> {

  CollectionReference usuarios = FirebaseFirestore.instance.collection("usuarios");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tu cuenta"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              tooltip: "Cerrar sesión",
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Sesión cerrada con éxito")
                  )
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ContadorPage()),
                      (Route<dynamic> route) => false,
                );
              }
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _deleteProgress(),
              _deleteAccount(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _userID()
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _deleteAccount() {
    String _mail = FirebaseAuth.instance.currentUser.email;

    print (_mail);
    return OutlinedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.red)
      ),
      child: Text("Borrar tu cuenta"),
      onPressed: () {
        _deleteAlert();
      },
    );
  }

  Widget _deleteProgress() {
    return OutlinedButton(
        child: Text("Borrar tu progreso"),
        onPressed: () {
          _progressAlert();
        },
    );
  }

  Widget _userID() {
    return Text("Tu UID es\n" + FirebaseAuth.instance.currentUser.uid.toString(),
        textAlign: TextAlign.center);
  }

  Future<void> _deleteAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Eliminar tu cuenta"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("¿Estás seguro de eliminar tu cuenta?"),
                  Text("Perderás todo el progreso en la nube."),
                  Text("Esta acción es irreversible."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.red)
                ),
                child: Text("Eliminar"),
                onPressed: () async {
                  try {
                    final _progreso = GetStorage("contador");
                    usuarios.doc(_progreso.read("uuid")).delete();
                    await FirebaseAuth.instance.currentUser.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Se ha eliminado tu cuenta con éxito."),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ContadorPage()),
                        (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    print(e);
                    if (e.code == "requires-recent-login") {
                    final _result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => ConfirmPage()));
                      if (_result == true) {
                        final _progreso = GetStorage("contador");
                        usuarios.doc(_progreso.read("uuid")).delete();
                        await FirebaseAuth.instance.currentUser.delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Se ha eliminado tu cuenta con éxito."),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ));
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ContadorPage()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                  }
                },
              ),
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  Future<void> _progressAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Eliminar tu progreso"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("¿Estás seguro de eliminar tu progreso?"),
                  Text("Perderás todo el progreso en la nube."),
                  Text("Esta acción es irreversible."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.red)
                ),
                child: Text("Eliminar"),
                onPressed: () async {
                  try {
                    final _progreso = GetStorage("contador");
                    usuarios.doc(_progreso.read("uuid")).delete();
                    await FirebaseAuth.instance.currentUser.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Se ha eliminado tu cuenta con éxito."),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ContadorPage()),
                          (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    print(e);
                    if (e.code == "requires-recent-login") {
                      final _result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => ConfirmPage()));
                      if (_result == true) {
                        final _progreso = GetStorage("contador");
                        usuarios.doc(_progreso.read("uuid")).delete();
                        await FirebaseAuth.instance.currentUser.delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Se ha eliminado tu cuenta con éxito."),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ));
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ContadorPage()),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }
                  }
                },
              ),
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}
