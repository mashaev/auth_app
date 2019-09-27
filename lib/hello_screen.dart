import 'dart:core';

import 'package:auth_app/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class HelloScreen extends StatefulWidget {
  @override
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  String name;

  List<Map<String, dynamic>> list = [];

  bool isList = true;

  Future<String> saveDataInDB(String note) async {
    try {
      Database db;
      try {
        db = await openDatabase(
          (await getDatabasesPath()) + '/notes.db',
        );
      } catch (e) {
        print(e.toString());
        return 'err in';
      }

      DbHelper helper = DbHelper();

      int res = await helper.insertNote(note);
      return res.toString();
    } catch (e) {
      print(e.toString());
      return 'err out';
    }
  }

  Future<List<Map<String, dynamic>>> getDataInDB({id = null}) async {
    try {
      Database db;
      try {
        db = await openDatabase(
          await getDatabasesPath() + '/notes.db',
        );
      } catch (e) {
        print(e.toString());
        return [
          {'err': e.toString(), 'type': 'in'}
        ];
      }

      DbHelper helper = DbHelper();
      List<Map<String, dynamic>> res = await helper.selectNote(id: id);
      return res;
    } catch (e) {
      print(e.toString());
      return [
        {'err': e.toString(), 'type': 'out'}
      ];
    }
  }

  Future<String> deleteDataInDB(String id) async {
    try {
      Database db;
      try {
        db = await openDatabase(
          (await getDatabasesPath()) + '/notes.db',
        );
      } catch (e) {
        print(e.toString());
        return 'err in';
      }

      DbHelper helper = DbHelper();

      int res = await helper.deleteNote(id);
      return res.toString();
    } catch (e) {
      print(e.toString());
      return 'err out';
    }
  }

  Future<String> updateDataInDB(String id, String noteUpdate) async {
    try {
      Database db;
      try {
        db = await openDatabase(
          (await getDatabasesPath()) + '/notes.db',
        );
      } catch (e) {
        print(e.toString());
        return 'err in';
      }

      DbHelper helper = DbHelper();

      int res = await helper.updateNote(id, noteUpdate);
      return res.toString();
    } catch (e) {
      print(e.toString());
      return 'err out';
    }
  }

  Future<void> _getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _getName();
    setList();
  }

  final _globalKey = GlobalKey<ScaffoldState>();

  var controllerAlert = TextEditingController();

  void _showAlertDialog({int index = null}) {
    controllerAlert.text = index == null ? '' : list[index]['note'];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                index == null ? 'Добавить заметки' : 'Редактировать заметку'),
            content: Container(
              child: TextFormField(
                controller: controllerAlert,
                decoration: InputDecoration(
                  labelText: index == null ? 'Новая Заметка' : 'Заметка',
                  hintText: 'Введите новую заметку',
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(index == null ? 'добавить' : 'сохранить'),
                onPressed: () async {
                  if (index == null) {
                    await saveDataInDB(controllerAlert.text);
                    await setList();
                    controllerAlert.clear();
                    Navigator.of(context).pop();
                  } else {
                    await updateDataInDB(
                        list[index]['id'].toString(), controllerAlert.text);
                    await setList();
                    controllerAlert.clear();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> setList() async {
    var awaitList = await getDataInDB();
    setState(() {
      list = awaitList;
    });
  }

  Future<void> deleteNote(id) async {
    await deleteDataInDB(id);
    await setList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Заметки'),
        actions: <Widget>[
          IconButton(
            icon: Icon(!isList ? Icons.list : Icons.apps),
            onPressed: () {
              setState(() {
                isList = !isList;
              });
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () async {
          //     print(await saveDataInDB('first'));
          //     print(await saveDataInDB('note2'));
          //     print(await saveDataInDB('заметка3'));
          //     print(await saveDataInDB('something'));
          //     print(await saveDataInDB('note5'));
          //     print(await getDataInDB());
          //   },
          // ),
        ],
      ),
      floatingActionButton: RaisedButton(
        child: Text('SnackBar'),
        onPressed: () {
          _globalKey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(seconds: 10),
              content: Text('SnackBar'),
              action: SnackBarAction(
                label: 'click',
                onPressed: () {
                  _showAlertDialog();
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Screen2()));
                },
              ),
            ),
          );
        },
      ),

      body: Center(
        child: Container(
          child: InkWell(
            child: isList
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (ctx, int index) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                alignment: Alignment.centerLeft,
                                height: 64,
                                child: Text(
                                  list[index]['note'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              onTap: () {
                                print(index);
                                print(list[index]);
                              },
                              onLongPress: () {
                                _showAlertDialog(index: index);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              // deleteNote();
                              deleteNote(list[index]['id'].toString());
                            },
                          ),
                        ],
                      );
                    },
                  )
                : GridView.builder(
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (ctx, int item) {
                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    // deleteNote();
                                    deleteNote(list[item]['id'].toString());
                                  },
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  //-------------------------------------------------
                                  child: Text(list[item]['note'],
                                      style: TextStyle(fontSize: 28)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          print(item);
                          print(list[item]);
                        },
                        onLongPress: () {
                          _showAlertDialog(index: item);
                        },
                      );
                    },
                  ),
          ),
        ),
      ),

      // body: Center(
      //   child: Column(

      //     children: <Widget>[
      //       SafeArea(
      //         child: Text('Привет, $name')
      //       ),

      //     ],
      //   ),
      // ),
    );
  }
}
