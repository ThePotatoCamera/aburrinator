import 'package:aburrinator/src/pages/account.page.dart';
import 'package:aburrinator/src/pages/helpers/database.helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ContadorPage extends StatefulWidget {

  @override
  createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> with WidgetsBindingObserver {

  String uid;
  int _contador = 0;

  final dbHelper = DatabaseHelper.instance;


  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var data = await _loadData();
      print(data);
      // uid = data["id"];
      // _contador = data["contador"];
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
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => AccountAdmin()));
                  print(FirebaseAuth.instance.currentUser.email);
                }
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tu nivel de aburrimiento:", style: TextStyle( fontSize: 25 ),),
            Text("$_contador", style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold ), )
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
        SizedBox(width: 30,),
        FloatingActionButton( child: Icon(Icons.refresh), onPressed: _restart, heroTag: "refreshbtn", ),
        Expanded(child: SizedBox()),
        FloatingActionButton( child: Icon(Icons.add), onPressed: _adicion,  heroTag: "addbtn", ),
      ],
    );
  }

  void _adicion() {
    setState(() {
      _contador ++;
    });
  }

  void _restart() {
    setState(() {
      _contador = 0;
    });
  }

  _loadData() async {
    final allRows = await dbHelper.queryAllRows();
    print(allRows);
  }

}
