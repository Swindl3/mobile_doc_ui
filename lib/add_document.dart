import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_doc/document.dart';
import 'package:image_cropper/image_cropper.dart';
import 'config.dart';

void main() {
  runApp(MaterialApp(
    home: AddDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AddDocumentScreen extends StatefulWidget {
  final String groupId;
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

  bool _validate = false;
  File _image;
  String txtImage;
  void confirmAddDoc() {
    if (_image != null) {
      List<int> imageStr = _image.readAsBytesSync();

      String base64 = base64Encode(imageStr);
      List<int> encode = utf8.encode(base64);
      String decode = utf8.decode(encode);
      txtImage = decode;
      print(txtImage);
    }

    Map<String, dynamic> param = Map();
    param['group_id'] = "${this.groupId}";
    param['doc_name'] = _name.text;
    param['doc_description'] = _detail.text;
    param['doc_picture'] = txtImage;

    if (_name.text == "" || _detail.text == "" || txtImage == "") {
      _validate = true;
      print(
          "ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
      setState(() {});
    } else {
      _validate = false;
      http.post("${Config.api_url}/api/adddoc", body: param).then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        String status = resMap['status'];
        if (status == "success") {
          setState(() {
            _showDialogSuccess();
          });
        } else {}
      });
    }
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

  _askedToLead() async {
    switch (await showDialog<Document>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getImageGallery(ImageSource.gallery);
                },
                child: const Text('Gallery'),
              ),
            ],
          );
        })) {
    }
  }

  getImage(ImageSource source) async {
    // await Navigator.of(context).pop();
    File image = await ImagePicker.pickImage(source: source);
    print(image);
    if(image != null) {
      File cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(
                ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarTitle: "RPS Cropper",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
            )
        );

        this.setState((){
          _image = cropped;
          
        });
    }
  }

  getImageGallery(ImageSource source) async {
    // await Navigator.of(context).pop();
    File image = await ImagePicker.pickImage(source: source);
     if(image != null) {
      File cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(
                ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarTitle: "RPS Cropper",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
            )
        );

        this.setState((){
          _image = cropped;
          
        });
    }
    // setState(() {
    //   _image = image;
    // });
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
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: _name,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "รายละเอียดเอกสาร",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
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
                onPressed: confirmAddDoc,
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
