import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_doc/document.dart';
import 'package:photo_view/photo_view.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'globalfunc.dart';
void main() {
  runApp(MaterialApp(
    home: EditDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class EditDocumentScreen extends StatefulWidget {
  final String docName;
  final String docDesc;
  final String docPic;
  final String docId;
  final String docObjt;
  EditDocumentScreen(
      {Key key,
      this.docName,
      this.docDesc,
      this.docPic,
      this.docId,
      this.docObjt})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditDocumentScreen(
        this.docName, this.docDesc, this.docPic, this.docId, this.docObjt);
  }
}

class _EditDocumentScreen extends State {
  String docName;
  String docDesc;
  String docPic;
  String docId;
  String docObjt;
  _EditDocumentScreen(
      this.docName, this.docDesc, this.docPic, this.docId, this.docObjt);
  String txtImage;
  var _docName = new TextEditingController();
  var _docDesc = new TextEditingController();
  var _docObjt = new TextEditingController();
  void onConfirm() async {
    print(docId);
    print(docName);
    print(docDesc);
    print(docPic);
    if (_image != null) {
      List<int> imageStr = _image.readAsBytesSync();
      String base64 = base64Encode(imageStr);
      List<int> encode = utf8.encode(base64);
      String decode = utf8.decode(encode);
      txtImage = decode;
      // print(txtImage);
      Map<String, String> params = Map();
      params['doc_id'] = docId;
      params['doc_name'] = _docName.text;
      params['doc_description'] = _docDesc.text;
      params['doc_picture'] = txtImage;
      // print(params);
      http.post('${Config.api_url}/api/editdoc', body: params).then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        bool status = resMap['success'];
        if (status == true) {
          setState(() {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()));
          });
        } else {}
      });
    } else {}
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
    if (image != null) {
      File croppedFile = await GlobalFunction().cropImg(image);

      this.setState(() {
        _image = croppedFile;
      });
    }
  }

  Future getImageGallery() async {
    await Navigator.of(context).pop();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File croppedFile = await GlobalFunction().cropImg(image);

      this.setState(() {
        _image = croppedFile;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _docName.text = docName.toString();
    _docDesc.text = docDesc.toString();
    _docObjt.text = docObjt.toString();
    print("IMAGE :::::::" + _image.toString());
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
                controller: _docName,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "รายละเอียดเอกสาร",
                    contentPadding: EdgeInsets.all(10.0)),
                controller: _docDesc,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "แจ้งเพื่อ",
                    contentPadding: EdgeInsets.all(10.0)),
                controller: _docObjt,
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
                height: 300.0,
                width: 300.0,
                margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Center(
                  child: _image == null
                      ? new PhotoView(
                          imageProvider:
                              NetworkImage("${Config.img_url}/" + docPic),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                        )
                      : new PhotoView(
                          imageProvider: FileImage(_image),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                        ),
                )),
            Container(
              margin: EdgeInsets.only(
                  left: 60.0, right: 60.0, top: 30.0, bottom: 30.0),
              child: RaisedButton(
                onPressed: onConfirm,
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
