import 'package:flutter/material.dart';
import 'package:mobile_doc/detail_user.dart';
import 'package:mobile_doc/document.dart';
import 'package:mobile_doc/add_group.dart';
import 'package:mobile_doc/edit_group.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

import 'group.dart';

void main() {
  runApp(MaterialApp(
    home: CreateGroupScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class CreateGroupScreen extends StatefulWidget {
  final userId;
  CreateGroupScreen({Key key, this.userId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CreateGroupScreen(this.userId);
  }
}

class _CreateGroupScreen extends State {
  String userId;
  _CreateGroupScreen(this.userId);
  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);
  List userGroup = [];
  bool _validate = false;
  TextEditingController groupUserName = TextEditingController();
  sendList() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("เพิ่มกลุ่ม", style: TextStyle(fontSize: 16.0)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "ชื่อกลุ่ม",
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.people),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: groupUserName,
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RaisedButton(
                        child: Text("ยืนยัน"),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          addUserToGroup();
                        })),
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RaisedButton(
                        child: Text("ยกเลิก"),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          groupUserName.clear();
                          Navigator.of(context).pop();
                        }))
              ],
            )
          ])));
        });
  }

  String insertId;
  int count = 0;
  void addUserToGroup() async {
    if (groupUserName.text.trim().isEmpty) {
      _validate = true;
      print("Empty");
    } else {
      _validate = false;
      Map<String, String> params = Map();
      params['groupuser_name'] = groupUserName.text.trim();
      params['user_id'] = userId;
      http
          .post('${Config.api_url}/api/creategroupuser', body: params)
          .then((response) {
        Map resMap = jsonDecode(response.body) as Map;
        bool status = resMap['success'];
        if (status == true) {
          insertId = resMap['body']['insertId'].toString();
          print("INSERT ID IS : ${insertId}");
          for (var user in userGroup) {
            http.post('${Config.api_url}/api/createuserdoc', body: {
              'groupuser_id': insertId,
              'user_id': user.toString()
            }).then((response) {
              Map resMap = jsonDecode(response.body) as Map;
              bool status = resMap['success'];
              if (status == true) {
                count = count + 1;
                print('TRUEEEEEEEEEEEEEEE IN TIME 2');
                if (userGroup.length == count) {
                  print(userGroup.length);
                  print(count);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext) => GroupScreen(userId: userId)));
                }
              }
            });
          }
        } else {
          print("Insert Failed");
        }
      });
    }
  }

  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();
  Future<List<Note>> fetchNotes() async {
    var url = "${Config.api_url}/api/getuser";
    var response = await http.post(url, body: {"user_id": userId});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      print(notesJson['body']);
      print(response.body);
      for (var noteJson in notesJson['body']) {
        print(noteJson['group_name']);
        print(noteJson['group_id']);
        notes.add(Note.fromJson(noteJson));
      }
      setState(() {});
    }
    return notes;
  }

  confirmDialogDel(String id) async {
    // flutter defined function
    await Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("แน่ใจที่จะลบ"),
          content: new Text("แน่ใจที่จะลบ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("ตกลง"),
              onPressed: () => confirmDelgroup(id),
            ),
          ],
        );
      },
    );
  }

  confirmDelgroup(String id) async {
    print("IDIDIDIDIDIDIIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIIDIDIDIDIDIDIDI" +
        "  " +
        id);
    await Navigator.of(context).pop();
    print("confirmDelgroup");
    http.post("${Config.api_url}/api/delgroup", body: {"group_id": id}).then(
        (response) {
      print(response.body);
      Map resMap = jsonDecode(response.body) as Map;
      bool status = resMap['success'];
      if (status == true) {
        print("status == true");
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreateGroupScreen()));
        });
      } else {}
    });
  }

  _askedToLead(String id, String groupName, String groupDesc) async {
    print("IDIDIDIDIDIDIIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIIDIDIDIDIDIDIDI" +
        "  " +
        id);
    String r_id = id;
    switch (await showDialog<Group>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => getEditGroup(groupName, groupDesc, id),
                child: const Text('แก้ไข'),
              ),
              SimpleDialogOption(
                onPressed: () => confirmDialogDel(r_id),
                child: const Text('ลบ'),
              ),
            ],
          );
        })) {
    }
  }

  @override
  void initState() {
    userGroup.clear();
    print("userGroup init : ${userGroup}");
    userGroup.add(userId);
    print("userGroup init : ${userGroup}");
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);
    super.initState();
  }

  Future getEditGroup(
      String groupName, String groupDesc, String groupId) async {
    await Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditGroupScreen(
              groupName: groupName,
              groupDesc: groupDesc,
              groupId: groupId,
            )));

    setState(() {});
  }

  Future getDeleteGruop() async {
    await Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditGroupScreen()));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สร้างกลุ่ม"),
        actions: <Widget>[
          userGroup.length > 1
              ? IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30.0,
                  onPressed: () => sendList())
              : IconButton(icon: Icon(Icons.add), iconSize: 30.0)
          // print(userGroup.toSet().toList())
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ashish Rawat"),
              accountEmail: Text("ashishrawat2911@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "ABC",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("ข้อมูลผู้ใช้งาน"),
              leading: Icon(Icons.account_circle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => DetailUserScreen()));
              },
            ),
            ListTile(
              title: Text("เพิ่มกลุ่ม"),
              leading: Icon(Icons.add),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AddGroupScreen()));
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index - 1);
        },
        itemCount: _notesForDisplay.length + 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext) => AddGroupScreen()))
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _notesForDisplay = _notes.where((note) {
              var noteTitle = note.mixedForSearch.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    String id = "${_notesForDisplay[index].userId}";
    // String groupName = "${_notesForDisplay[index].groupName}";
    // String groupDesc = "${_notesForDisplay[index].groupDesc}";
    return new Column(
      children: <Widget>[
        ListTile(
          leading: Image.asset("images/group.png"),
          title: Text(
            "${_notesForDisplay[index].userName}",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("${_notesForDisplay[index].firstName}" +
              "  " +
              "${_notesForDisplay[index].lastName}"),
          trailing: (_notesForDisplay[index].selected)
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
          onTap: () {
            print(_notesForDisplay[index].userId);
            print(_notesForDisplay[index].selected);
            setState(() {
              _notesForDisplay[index].selected =
                  !_notesForDisplay[index].selected;
              log(_notesForDisplay[index].selected.toString());
              if (_notesForDisplay[index].selected == true) {
                userGroup.add(_notesForDisplay[index].userId);
              } else if (_notesForDisplay[index].selected == false) {
                userGroup.remove(_notesForDisplay[index].userId);
              }
            });
          },
          selected: _notesForDisplay[index].selected,
          onLongPress: () {
            // _askedToLead(id, groupName, groupDesc);
          },
        ),
        Divider(
          height: 2.0,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}

class Group {}

class Note {
  String firstName;
  String userId;
  String lastName;
  String userName;
  String mixedForSearch;
  Note(this.firstName);
  bool selected = false;
  // Note(this.groupId);
  Note.fromJson(Map<String, dynamic> json) {
    firstName = json['user_fname'];
    userId = json['user_id'].toString();
    lastName = json['user_lname'];
    userName = json['user_username'];
    mixedForSearch = firstName + lastName + userName;
  }
}
