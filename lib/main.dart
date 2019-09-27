import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auth_app/reg_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Приветствие'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<String> _getSelfPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String password = prefs.getString('name') ?? "";
    // если prefs.getString('pass') == null то пустая строка
    //иначе password == prefs.getString('pass')
    return password;
  }

  Future check() async {
    if(await _getSelfPassword() == ''){
      Timer(Duration(seconds: 3), (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegScreen()));
      });
    }else{
      Timer(Duration(seconds: 3), (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthScreen()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    check();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Sharedpreferance'),
      ),
    );
  }
}
