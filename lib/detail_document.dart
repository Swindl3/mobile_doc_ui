import 'package:flutter/material.dart';
import 'package:mobile_doc/edit_document.dart';

import 'add_document.dart';

void main() {
  runApp(MaterialApp(
    home: DetailDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DetailDocumentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailDocumentScreen();
  }
}

class _DetailDocumentScreen extends State {
  void click() {
    print("click");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("หน้ารายละเอียดเอกสาร"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          Container(
            child: Text("รายละเอียดเอกสาร", style: TextStyle(fontSize: 18.0)),
            margin: EdgeInsets.only(top: 30.0),
          ),
          Container(
            child: Text(
              "วันที่อัปโหลด",
              style: TextStyle(fontSize: 16.0),
            ),
            margin: EdgeInsets.only(top: 20.0, right: 20.0),
          ),
          Container(
            child: Text(
              "วันที่แก้ไขล่าสุด",
              style: TextStyle(fontSize: 16.0),
            ),
            margin: EdgeInsets.only(top: 20.0, right: 20.0),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0, right: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FloatingActionButton.extended(
                        label: Text("ดาวน์โหลด"),
                        heroTag: "btn_download",
                        icon: Icon(Icons.file_download),
                        backgroundColor: Colors.blue,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      new FloatingActionButton.extended(
                        label: Text("แชร์"),
                        heroTag: "btn_share",
                        icon: Icon(Icons.share),
                        backgroundColor: Colors.blue,
                        onPressed: () {},
                      ),
                    ],
                  )
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: FloatingActionButton.extended(
              label: Text("แก้ไข"),
              icon: Icon(Icons.edit),
              backgroundColor: Colors.blue,
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext) => EditDocumentScreen()))
              },
            ),
          ),
          Container(
            child: Image.asset("images/logo.png"),
            margin: EdgeInsets.all(30.0),
            height: 300.0,
            width: 300.0,
          )
        ]))));
  }
}
