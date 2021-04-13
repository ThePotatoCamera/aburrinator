import 'package:aburrinator/src/routes/routes.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return fatalError();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Aburrinator',
              initialRoute: "/",
              routes: getApplicationRoutes(),
            );
          }
          return loading();
        });
  }

  Widget fatalError() {
    return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("No hemos podido iniciar los servicios de Google."),
        Text("Prueba reiniciando la app.")
      ],
    ),
    );
  }

  Widget loading() {
    return Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
