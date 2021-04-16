import 'package:aburrinator/src/routes/routes.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:get/get.dart';

void main() async {
  runApp(MyApp());
}

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
            return GetMaterialApp(
              title: 'Aburrinator',
              initialRoute: "/",
              routes: getApplicationRoutes(),
              locale: Get.deviceLocale,
              fallbackLocale: Locale("es", "ES"),
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
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}