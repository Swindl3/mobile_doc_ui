import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_doc/document.dart';

import 'config.dart';

void main() {
  runApp(MaterialApp(
    home: AddDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AddDocumentScreen extends StatefulWidget {
  final String groupId ;
  AddDocumentScreen({Key key, this.groupId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddDocumentScreen(this.groupId);
  }
}

class _AddDocumentScreen extends State {
  String groupId;
  _AddDocumentScreen(this.groupId);
 
  TextEditingController _name = TextEditingController();
  TextEditingController _detail = TextEditingController();
    void confirmAddDoc() {
        Map<String, dynamic> param = Map();
    param['group_id'] = "${this.groupId}";
    param['doc_name'] = _name.text;
    param['doc_description'] = _detail.text;

    http.post("${Config.api_url}/api/adddoc", body: param).then((response) {
      print(response.body);
      Map resMap = jsonDecode(response.body) as Map;
      String status = resMap['status'];
      if (status == "success") {
        setState(() {
          _showDialogSuccess();
        });
      } else {

      }
    });
  }
  void _showDialogSuccess() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("เพิ่มเอกสารสำเร็จ"),
          content: new Text("เพิ่มเอกสารสำเร็จ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext) => DocumentScreen(
                        groupId: "${this.groupId}",
                      )));
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _askedToLead() async {
    switch (await showDialog<Document>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: getImage,
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: getImageGallery,
                child: const Text('Gallery'),
              ),
            ],
          );
        })) {
    }
  }

  File _image;

  Future getImage() async {
    await Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageGallery() async {
    await Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าเพิ่มเอกสาร"),
        ),
        body: ListView(
           
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "ชื่อเอกสาร",
                    contentPadding: EdgeInsets.all(10.0)),
                    controller: _name,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "รายละเอียดเอกสาร",
                    contentPadding: EdgeInsets.all(10.0)),
                    controller: _detail,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 30.0, bottom: 30.0, right: 100.0, left: 100.0),
              child: FloatingActionButton.extended(
                onPressed: _askedToLead,
                icon: Icon(Icons.add),
                label: Text("เพิ่มเอกสาร"),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Center(
                  child: _image == null
                      ? new Text("No image selcted")
                      : new Image.file(_image),
                )),
            Container(
              margin: EdgeInsets.only(
                  left: 60.0, right: 60.0, top: 30.0, bottom: 30.0),
              child: RaisedButton(
                onPressed:confirmAddDoc ,
                color: Colors.green,
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'ยืนยัน',
                  
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}

class Document {
  static get treasury => null;

  static get state => null;
}
