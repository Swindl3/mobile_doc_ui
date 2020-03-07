import 'package:flutter/material.dart';
import 'package:mobile_doc/detail_user.dart';
import 'package:mobile_doc/document.dart';
import 'package:mobile_doc/add_group.dart';
import 'package:mobile_doc/edit_group.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_doc/home.dart';
import 'package:mobile_doc/manage_user.dart';
import 'dart:convert';
import 'dart:async';
import 'config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_doc/group_user.dart';

void main() {
  runApp(MaterialApp(
    home: GroupScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class GroupScreen extends StatefulWidget {
  final String userId;
  GroupScreen({Key key, this.userId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GroupScreen(this.userId);
  }
}

class _GroupScreen extends State {
  String userId;

  String groupUserId;
  _GroupScreen(this.userId);
  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);
  var notes = List<Note>();
  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();
  Future<List<Note>> fetchNotes() async {
    var url = "${Config.api_url}/api/getgroupuser";
    var response = await http.post(url, body: {"user_id": userId});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      print(notesJson['body']);
      print(response.body);
      for (var noteJson in notesJson['body']) {
        notes.add(Note.fromJson(noteJson));
      }
      setState(() {});
    }
    return notes;
  }

  bool _validate = false;
  var groupUserName = TextEditingController();
  editGroupName(String groupUserId, String groupName) {
    groupUserName.text = groupName;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                content: Form(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("แก้ไขชื่อกลุ่ม",
                        style: TextStyle(fontSize: 16.0)),
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
                                setState(() {
                                  groupUserName.text.trim() == ""
                                      ? _validate = true
                                      : Navigator.of(context).pop();
                                  editGroup(groupUserId, groupUserName.text); 
                                });
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
        });
  }

  void editGroup(String groupUserId, String groupUserName) {
    Map<String, dynamic> param = Map();

    if (groupUserName.trim() == "") {
      _validate = true;
      print("String Empty");
    } else {
      param['groupuser_name'] = groupUserName;
      param['groupuser_id'] = groupUserId;
      _validate = false;
      http
          .post("${Config.api_url}/api/editgroupname", body: param)
          .then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        String status = resMap['status'];
        if (status == "success") {
          setState(() {
              
                Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => GroupScreen(
                    userId: userId,
                  )));
                  // Navigator.of(context).pop().;
          });
        } else {}
      });
    }
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
    http.post("${Config.api_url}/api/delgroupuser",
        body: {"groupuser_id": id}).then((response) {
      print(response.body);
      Map resMap = jsonDecode(response.body) as Map;
      bool status = resMap['success'];
      if (status == true) {
        print("status == true");
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => GroupScreen(
                    userId: userId,
                  )));
        });
      } else {}
    });
  }

  _askedToLead(String groupUserId, String groupName) async {
    print("groupUserIdgroupUserIdgroupUserIdgroupUserIdgroupUserId" +
        "  " +
        groupUserId);
    print("userIduserIduserIduserIduserIduserId" + userId);
    switch (await showDialog<Group>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  UserGroupScreen(userId: userId),
                  AddUserGroupScreen(
                    userId: userId,
                    groupUserId: groupUserId,
                  ),
                  Navigator.of(context).pop(),
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ManageUserTab(
                            groupUserId: groupUserId,
                            userId: userId,
                          )))
                },
                child: const Text('จัดการสมาชิก'),
              ),
              SimpleDialogOption(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  editGroupName(groupUserId, groupName)
                },
                child: const Text('แก้ไข'),
              ),
              SimpleDialogOption(
                onPressed: () => {
                  Navigator.of(context).pop(),
                  confirmDialogDel(groupUserId)
                },
                child: const Text('ลบ'),
              ),
            ],
          );
        })) {
    }
  }

  @override
  void initState() {
    print(
        "userId isssssssssssssssssssssssssssssssssssssssssssssssssssssssss   ::   ${userId}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("กลุ่มของฉัน"),
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => CreateGroupScreen(
                    userId: userId,
                  )))
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
              var noteTitle = note.groupUserName.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    // String id = "${_notesForDisplay[index].groupId}";
    // String groupName = "${_notesForDisplay[index].groupName}";
    // String groupDesc = "${_notesForDisplay[index].groupDesc}";
    String idUsercreateGroup = "${_notesForDisplay[index].noteUserId}";
    print("User id is : ${userId} and idCompare is : ${idUsercreateGroup}");
    print(
        "USER IDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD IS ${userId}");
    return new Column(
      children: <Widget>[
        ListTile(
          leading: Image.asset("images/group.png"),
          title: Text(
            "${_notesForDisplay[index].groupUserName}",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // subtitle: Text("${_notesForDisplay[index].groupDesc}"),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => HomeScreen(
                      groupUserId: "${_notesForDisplay[index].groupUserId}",
                      userId: userId,
                    )));
          },
          onLongPress: () {
            userId == idUsercreateGroup
                ? _askedToLead("${_notesForDisplay[index].groupUserId}",
                    "${_notesForDisplay[index].groupUserName}")
                : null;
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
  String groupUserName;
  String groupUserId;
  String noteUserId;
  Note(this.groupUserName);
  // Note(this.groupId);
  Note.fromJson(Map<String, dynamic> json) {
    groupUserName = json['groupuser_name'];
    groupUserId = json['groupuser_id'].toString();
    noteUserId = json['user_id'].toString();
  }
}
