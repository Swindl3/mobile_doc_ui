import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DetailUserScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DetailUserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailUserScreen();
  }
}

class _DetailUserScreen extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ข้อมูลผู้ใช้งาน"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextField(
                    decoration: InputDecoration(
                  hintText: "FirstName",
                  contentPadding: EdgeInsets.all(10.0),
                ))),
            Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextField(
                    decoration: InputDecoration(
                  hintText: "LastName",
                  contentPadding: EdgeInsets.all(10.0),
                ))),
            Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextField(
                    decoration: InputDecoration(
                  hintText: "Email",
                  contentPadding: EdgeInsets.all(10.0),
                ))),
            Container(
                margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
                child: RaisedButton(
                  onPressed: () => {},
                  color: Colors.green,
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ));
  }
}
