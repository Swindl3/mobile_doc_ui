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

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  final groupUserId;
  final userId;
  HomeScreen({Key key, this.groupUserId, this.userId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen(this.groupUserId, this.userId);
  }
}

class _HomeScreen extends State {
  String groupUserId;
  String userId;
  _HomeScreen(this.groupUserId, this.userId);
  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);

  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();
  Future<List<Note>> fetchNotes() async {
    var url = "${Config.api_url}/api/getgroup";
    var response = await http.post(url, body: {"groupuser_id": groupUserId});
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
              builder: (BuildContext context) => HomeScreen(
                    groupUserId: groupUserId,
                    userId: userId,
                  )));
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
    print("HOME SCREEN user ID is ${userId}");
    print("HOME SCREEN user ID is ${groupUserId}");
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
  bool _validate = false;
  var groupNameEdit = TextEditingController();
  var groupDescEdit = TextEditingController();
  Future getEditGroup(
      String groupName, String groupDesc, String groupId) async {
        groupNameEdit.text = groupName;
        groupDescEdit.text = groupDesc;
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
                      controller: groupNameEdit,
                    ),
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
                      controller: groupDescEdit,
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
                                  groupNameEdit.text.trim() == "" || groupDescEdit.text.trim() == ""
                                      ? _validate = true
                                      : editGroup(groupNameEdit.text, groupDescEdit.text,groupId);
                                  
                                });
                              })),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RaisedButton(
                              child: Text("ยกเลิก"),
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () {
                                groupNameEdit.clear();
                                groupDescEdit.clear();
                                Navigator.of(context).pop();
                              }))
                    ],
                  )
                ])));
          });
        });

    // await Navigator.of(context).pop();
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => EditGroupScreen(
    //           groupName: groupName,
    //           groupDesc: groupDesc,
    //           groupId: groupId,
    //         )));

    // setState(() {});
  }
    void editGroup(String groupName ,String groupDesc , String groupId) {

    Map<String, String> params = Map();
    params['group_id'] = groupId;
    params['group_description'] = groupDesc;
    params['group_name'] = groupName;
    print(params);
    http.post('${Config.api_url}/api/editgroup', body: params).then((response) {
      print(response.body);
      Map resMap = jsonDecode(response.body) as Map;
      bool status = resMap['success'];
      if (status == true) {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(groupUserId: groupUserId,userId: userId,)));
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประเภทเอกสาร"),
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
              builder: (BuildContext) => AddGroupScreen(
                    groupUserId: groupUserId,
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
              var noteTitle = note.groupName.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    String id = "${_notesForDisplay[index].groupId}";
    String groupName = "${_notesForDisplay[index].groupName}";
    String groupDesc = "${_notesForDisplay[index].groupDesc}";
    return new Column(
      children: <Widget>[
        ListTile(
          leading: Image.asset("images/group.png"),
          title: Text(
            "${_notesForDisplay[index].groupName}",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("${_notesForDisplay[index].groupDesc}"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => DocumentScreen(
                      groupUserId: groupUserId,
                      groupId: "${_notesForDisplay[index].groupId}",
                    )));
          },
          onLongPress: () {
            _askedToLead(id, groupName, groupDesc);
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
  String groupName;
  String groupId;
  String groupDesc;
  Note(this.groupName);
  // Note(this.groupId);
  Note.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name'];
    groupId = json['group_id'].toString();
    groupDesc = json['group_description'];
  }
}
