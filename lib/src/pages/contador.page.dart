import 'package:aburrinator/src/pages/account.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ContadorPage extends StatefulWidget {

  final int contador;

  ContadorPage(this.contador);

  @override
  createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {

  final progreso = GetStorage("contador");
  CollectionReference usuarios = FirebaseFirestore.instance.collection(
      "usuarios");

  String uid;
  int _contador = 0;
  bool _saveBtn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _contador = getContador();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Medidor de aburrimiento"),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.account_circle),
                tooltip: "Guardado en la nube",
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    Navigator.pushNamed(context, "login");
                  } else {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (builder) => AccountAdmin()));
                    print(FirebaseAuth.instance.currentUser.email);
                  }
                })
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tu nivel de aburrimiento:", style: TextStyle(fontSize: 25),),
              Text("$_contador",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        floatingActionButton: _floatingButtons()
    );
  }

  Widget _floatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(width: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(child: Icon(Icons.refresh),
              onPressed: _restart,
              heroTag: "refreshbtn"),
          ],
        ),
        Expanded(child: SizedBox()),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _showCloudSave(),
            SizedBox(height: 10),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: _adicion,
              heroTag: "addbtn"),
          ],
        )
      ],
    );
  }

  void _adicion() {
    setState(() {
      _contador ++;
      progreso.write("contador", _contador);
      _saveBtn = true;
    });
  }

  void _restart() {
    setState(() {
      _contador = 0;
      progreso.write("contador", 0);
      _saveBtn = true;
    });
  }

  Widget _showCloudSave() {
    if (FirebaseAuth.instance.currentUser != null) {
      return new Visibility(
        visible: _saveBtn,
        child: new FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed:() => _guardarNube(),
        )
      );
    }
    return Container();
  }

  getContador() {
      _contador = widget.contador;
      if (_contador == null) {
        if (progreso.hasData("contador")) {
          _contador = progreso.read("contador");
        }
        else {
          _contador = 0;
          progreso.write("contador", 0);
        }
      }
      return _contador;
  }

  void _guardarNube() {
    setState(() {
      final loginUser = FirebaseAuth.instance.currentUser.uid;
      Map<String, dynamic> localData = {
        "contador": progreso.read("contador"),
      };
      usuarios
          .doc(loginUser)
          .set(localData)
          .then((value) =>
          print("Se han guardado los datos del usuario en $loginUser"));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Se ha guardado tu progreso con éxito"),
            duration: Duration(seconds: 2),
          )
      );
      _saveBtn = false;
    });
  }
}
