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
import 'home.dart';

void main() {
  runApp(MaterialApp(
    home: DocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DocumentScreen extends StatefulWidget {
   final String groupId ;
  DocumentScreen({Key key, this.groupId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DocumentScreen(this.groupId);
  }
}

class _DocumentScreen extends State {
  String groupId;
  _DocumentScreen(this.groupId);

  String filteredUser(String s) => s[0].toUpperCase() + s.substring(1);

  List<Note> _notes = List<Note>();
  List<Note> _notesForDisplay = List<Note>();

  Future<List<Note>> fetchNotes() async {
    
    var url = "${Config.api_url}/api/getdoc";
    var response = await http.post(url,body: {"group_id":"${this.groupId}"});
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

  Future<void> _askedToLead() async {
    switch (await showDialog<Group>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: getEditGruop,
                child: const Text('แก้ไข'),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('ลบ'),
              ),
            ],
          );
        })) {
    }
  }

  @override
  void initState() {
    
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  Future getEditGruop() async {
    await Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditDocumentScreen()));

    setState(() {});
  }

  Future getDeleteGruop() async {
    await Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditDocumentScreen()));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าเอกสาร"),
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
              MaterialPageRoute(builder: (BuildContext) => AddDocumentScreen(
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
          leading: Image.asset("images/document.png"),
          title: Text(
            "${_notesForDisplay[index].docName}",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("12-3343-44"),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext) => DetailDocumentScreen()));
          },
          onLongPress: () {
            _askedToLead();
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

  Note(this.docName);
  // Note(this.groupId);
  Note.fromJson(Map<String, dynamic> json) {
    docName = json['doc_name'];
  }
}
