import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ChangePasswordScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreen();
  }
}

class _ChangePasswordScreen extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("เปลี่ยนรหัสผ่าน"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextField(
                    decoration: InputDecoration(
                  hintText: "OldPassword",
                  contentPadding: EdgeInsets.all(10.0),
                ))),
            Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextField(
                    decoration: InputDecoration(
                  hintText: "NewPassword",
                  contentPadding: EdgeInsets.all(10.0),
                ))),Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: TextField(
                    decoration: InputDecoration(
                  hintText: "ConfrimPassword",
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
