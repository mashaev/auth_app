import 'package:auth_app/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hello_screen.dart';

class RegScreen extends StatefulWidget {
  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {


 

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passRController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title:Text('Регистрация')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Введите имя',
                  helperText: 'Введите имя',
                  labelText: 'Имя',
                ),

              ),
            ),
            Container(
              child: TextFormField(
                controller: passController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Введите пароль',
                  helperText: 'Введите пароль',
                  labelText: 'Пароль',
                ),

              ),
            ),
            Container(
              child: TextFormField(
                controller: passRController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Подтвердите пароль',
                  helperText: 'Подтвердите пароль',
                  labelText: 'Подтвердите пароль',
                ),

              ),
            ),
            Container(
              child: RaisedButton(
                child: Text('Регистрация'),
                onPressed: ()async{
                  if(passController.text == passRController.text){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('name', nameController.text);
                    await prefs.setString('pass', passController.text);
                    await prefs.setInt('count', 0);
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context)=>HelloScreen()));
                        
                  }else{
                    
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Пароли не совпадают')));
                  }
                },
              ),
            )
          ],
        ),
    );
  }
}
