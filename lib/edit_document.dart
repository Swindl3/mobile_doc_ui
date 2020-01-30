import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_doc/document.dart';

void main() {
  runApp(MaterialApp(
    home: EditDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class EditDocumentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditDocumentScreen();
  }
}

class _EditDocumentScreen extends State {
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
          title: Text("หน้าแก้ไขเอกสาร"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "ชื่อเอกสาร",
                    contentPadding: EdgeInsets.all(10.0)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "รายละเอียดเอกสาร",
                    contentPadding: EdgeInsets.all(10.0)),
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
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext) => DocumentScreen()))
                },
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
