import 'package:aburrinator/src/pages/contador.page.dart';
import 'package:aburrinator/src/pages/auth/login.page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  final rutas = <String, WidgetBuilder>{
    "/": (BuildContext context) => ContadorPage(0),
    "login": (BuildContext context) => LoginPage()
  };

  return rutas;
}