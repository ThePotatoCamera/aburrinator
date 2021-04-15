import 'package:aburrinator/src/routes/routes.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

void main() async {
  await GetStorage.init("contador");
  _generateUuid();
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

void _generateUuid() async {

  final progreso = GetStorage("contador");
  var uuid = Uuid();

  if (!progreso.hasData("uuid")) {
    var userid = uuid.v1();
    await progreso.write("uuid", userid);
    print(progreso.read("uuid"));
  }
  print(progreso.read("uuid"));
}
