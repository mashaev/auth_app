import 'package:flutter/material.dart';
import 'package:auth_app/reg_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hello_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  TextEditingController passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int err = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
              child: RaisedButton(
                child: Text('Войти'),
                onPressed: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  if(passController.text == prefs.getString('pass')){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>HelloScreen()));
                  }else{
                     err = await prefs.getInt('count');
                     err++;
                     await prefs.setInt('count', err);
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Пароль не верный')));
                       if(err>=3){
                         prefs.clear();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>RegScreen()));
                       }

                        
                  }
                },
              ),
            ),

            Container(
              child: InkWell(
                child: Text('Забыли пароль?'),
                onTap: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text('Вы хотите сбросить пароль,'), action: SnackBarAction(
                      label: 'да',
                      onPressed: (){
                        prefs.clear();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>RegScreen()));
                      },
                    ),)
                  );
                  
                 
                   
                  
                },
              ),
            )
            
        ],
      ),
      
    );
  }
}