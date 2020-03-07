import 'package:flutter/material.dart';
import 'package:mobile_doc/add_group.dart';
import 'package:mobile_doc/detail_document.dart';
import 'package:mobile_doc/edit_group.dart';
import 'package:mobile_doc/group.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'config.dart';
import 'dart:developer';

void main() {
  runApp(MaterialApp(
    home: ManageUserTab(),
    debugShowCheckedModeBanner: false,
  ));
}

class ManageUserTab extends StatefulWidget {
  final String userId;
  final String groupUserId;
  ManageUserTab({Key key, this.userId, this.groupUserId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ManageUserTab(this.userId, this.groupUserId);
  }
}

class _ManageUserTab extends State {
  String userId;
  String groupUserId;
  _ManageUserTab(this.userId, this.groupUserId);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "สมาชิก"),
              Tab(text: "เพิ่มสมาชิก"),
            ],
          ),
          title: Text('จัดการข้อมูลสมาชิก'),
        ),
        body: TabBarView(
          children: [
            UserGroupScreen(userId: userId, groupUserId: groupUserId),
            AddUserGroupScreen(
              groupUserId: groupUserId,
              userId: userId,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    print(
        "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" +
            userId);
    print(
        "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" +
            groupUserId);
    // UserGroupScreen(userId: userId);
    // AddUserGroupScreen(userId: userId,groupUserId: groupUserId,);
    super.initState();
  }
}

class UserGroupScreen extends StatefulWidget {
  final String userId;
  final String groupUserId;
  UserGroupScreen({Key key, this.userId, this.groupUserId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserGroupScreen(this.userId, this.groupUserId);
  }
}

class _UserGroupScreen extends State {
  String userId;
  String groupUserId;
  _UserGroupScreen(this.userId, this.groupUserId);
  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);
  List userGroup = [];
  bool _validate = false;
  TextEditingController groupUserName = TextEditingController();

  List<NoteManageUser> _notes = List<NoteManageUser>();
  List<NoteManageUser> _notesForDisplay = List<NoteManageUser>();
  Future<List<NoteManageUser>> fetchNotes() async {
    var url = "${Config.api_url}/api/getuseringroup";
    var response = await http.post(url, body: {"groupuser_id": groupUserId});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var notes = List<NoteManageUser>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      print(notesJson['body']);
      print(response.body);
      for (var noteJson in notesJson['body']) {
        notes.add(NoteManageUser.fromJson(noteJson));
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
              onPressed: () => {},
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    userGroup.clear();
    print("userGroup init : ${userGroup}");
    // userGroup.add(userId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index - 1);
        },
        itemCount: _notesForDisplay.length + 1,
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
          trailing: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                print("DELETE");
              }),
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

class NoteManageUser {
  String firstName;
  String userId;
  String lastName;
  String userName;
  String mixedForSearch;
  NoteManageUser(this.firstName);
  bool selected = false;
  // Note(this.groupId);
  NoteManageUser.fromJson(Map<String, dynamic> json) {
    firstName = json['user_fname'];
    userId = json['user_id'].toString();
    lastName = json['user_lname'];
    userName = json['user_username'];
    mixedForSearch = firstName + lastName + userName;
  }
}

class AddUserGroupScreen extends StatefulWidget {
  final String userId;
  final String groupUserId;
  AddUserGroupScreen({Key key, this.userId, this.groupUserId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddUserGroupScreen(this.userId, this.groupUserId);
  }
}

class _AddUserGroupScreen extends State {
  String userId;
  List userGroup = [];
  String groupUserId;
  _AddUserGroupScreen(this.userId, this.groupUserId);
  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);
  var notes = List<Note>();
  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();
  Future<List<Note>> fetchNotes() async {
    var url = "${Config.api_url}/api/getuseroutsidegroup";
    var response = await http.post(url, body: {"groupuser_id": groupUserId});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print(
          "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
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

  Future getEditGroup(
    String groupId,
    String groupName,
  ) async {
    await Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditGroupScreen(
              groupName: groupName,
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

  int count = 0;
  void addUserToGroup(List userGroup) async {
    for (var user in userGroup) {
      http.post('${Config.api_url}/api/createuserdoc', body: {
        'groupuser_id': groupUserId,
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
          } else {
            print(
                "FAILLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLl");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index - 1);
        },
        itemCount: _notesForDisplay.length + 1,
      ),
      floatingActionButton: userGroup.length > 0
          ? FloatingActionButton(
              onPressed: () => {addUserToGroup(userGroup.toSet().toList())},
              child: Icon(Icons.person_add),
              backgroundColor: Colors.blue,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              var noteTitle = note.fullName.toLowerCase();
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
              " " +
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
                // ManageUserTab(userGroup: userGroup);
              } else if (_notesForDisplay[index].selected == false) {
                userGroup.remove(_notesForDisplay[index].userId);
                // ManageUserTab(userGroup: userGroup);

              }
            });
          },
          selected: _notesForDisplay[index].selected,
          onLongPress: () {
            // userId == idUsercreateGroup
            //     ? _askedToLead("${_notesForDisplay[index].groupUserId}",
            //         "${_notesForDisplay[index].groupUserName}")
            //     : null;
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

class GroupAdd {}

class Note {
  String firstName;
  String userId;
  String lastName;
  String fullName;
  String userName;
  bool selected = false;
  Note(
      this.firstName, this.userId, this.lastName, this.fullName, this.userName);
  // Note(this.groupId);
  Note.fromJson(Map<String, dynamic> json) {
    firstName = json['user_fname'];
    userId = json['user_id'].toString();
    lastName = json['user_lname'].toString();
    userName = json['user_username'];
    fullName = firstName + lastName;
  }
}
