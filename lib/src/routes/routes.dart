import 'package:aburrinator/src/pages/contador_page.dart';
import 'package:aburrinator/src/pages/login_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  final rutas = <String, WidgetBuilder>{
    "/": (BuildContext context) => ContadorPage(),
    "login": (BuildContext context) => LoginPage()
  };

  return rutas;
}