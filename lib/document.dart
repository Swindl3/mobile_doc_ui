import 'package:flutter/material.dart';
import 'package:mobile_doc/detail_user.dart';
import 'package:mobile_doc/document.dart';
import 'package:mobile_doc/add_group.dart';
import 'package:mobile_doc/edit_group.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'config.dart';
import 'add_document.dart';
import 'detail_document.dart';
import 'edit_document.dart';
import 'doc_category.dart';

void main() {
  runApp(MaterialApp(
    home: DocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DocumentScreen extends StatefulWidget {
  final String groupId;
  final String groupUserId;
  DocumentScreen({Key key, this.groupId, this.groupUserId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DocumentScreen(this.groupId, this.groupUserId);
  }
}

class _DocumentScreen extends State {
  String groupId;
  String groupUserId;
  _DocumentScreen(this.groupId, this.groupUserId);

  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);

  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();

  Future<List<Note>> fetchNotes() async {
    var url = "${Config.api_url}/api/getdoc";
    var response = await http.post(url, body: {"group_id": "${this.groupId}"});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      print(notesJson['body']);
      print(response.body);
      for (var noteJson in notesJson['body']) {
        print(noteJson['doc_name']);
        // print(noteJson['group_id']);
        notes.add(Note.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<void> _askedToLead(String docName, String docDesc, String docPic,
      String docId, String docObjt) async {
    switch (await showDialog<Group>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () =>
                    getEditDoc(docName, docDesc, docPic, docId, docObjt),
                child: const Text('แก้ไข'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  confirmDialogDel(docId);
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
    print("DocumentScreennnnnnnnnnnnnnnnn ${groupUserId}");
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  Future getEditDoc(String docName, String docDesc, String docPic, String docId,
      String docObjt) async {
    await Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditDocumentScreen(
              docName: docName,
              docDesc: docDesc,
              docPic: docPic,
              docId: docId,
              docObjt: docObjt,
            )));

    setState(() {});
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
              onPressed: () => confirmDelDoc(id),
            ),
          ],
        );
      },
    );
  }

  confirmDelDoc(String id) async {
    print("IDIDIDIDIDIDIIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIDIIDIDIDIDIDIDIDI" +
        "  " +
        id);
    await Navigator.of(context).pop();
    print("confirmDelgroup");
    http.post("${Config.api_url}/api/deldoc", body: {"doc_id": id}).then(
        (response) {
      print(response.body);
      Map resMap = jsonDecode(response.body) as Map;
      bool status = resMap['success'];
      if (status == true) {
        print("status == true");
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => DocumentScreen(
                    groupId: groupId,
                  )));
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เอกสาร"),
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
              builder: (BuildContext) => AddDocumentScreen(
                    groupUserId: groupUserId,
                    groupId: "${this.groupId}",
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
              var noteTitle = note.docName.toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return new Column(
      children: <Widget>[
        ListTile(
          leading: Image.network("${Config.img_url}/" + "${_notesForDisplay[index].docPicture}"),
          title: Text(
            "${_notesForDisplay[index].docName}",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("${_notesForDisplay[index].docUpdate}"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => DetailDocumentScreen(
                      imgPath: "${_notesForDisplay[index].docPicture}",
                      docCreate: "${_notesForDisplay[index].docCreate}",
                      docUpdate: "${_notesForDisplay[index].docUpdate}",
                      docName: "${_notesForDisplay[index].docName}",
                      docDesc: "${_notesForDisplay[index].docDesc}",
                      docObjt: "${_notesForDisplay[index].docObjt}",
                      docId: "${_notesForDisplay[index].docId}",
                    )));
          },
          onLongPress: () {
            _askedToLead(
                "${_notesForDisplay[index].docName}",
                "${_notesForDisplay[index].docDesc}",
                "${_notesForDisplay[index].docPicture}",
                "${_notesForDisplay[index].docId}",
                "${_notesForDisplay[index].docObjt}");
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

class Note {
  String docName;
  String docPicture;
  String docDesc;
  String docId;
  String docObjt;
  String docCreate;
  String docUpdate;
  Note(this.docName);
  // Note(this.groupId);
  Note.fromJson(Map<String, dynamic> json) {
    docName = json['doc_name'];
    docPicture = json['doc_picture'];
    docDesc = json['doc_description'];
    docId = json['doc_id'].toString();
    docObjt = json['doc_objective'];
    docCreate = json['doc_create'].toString();
    docUpdate = json['doc_update'].toString();
  }
}
