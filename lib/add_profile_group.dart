import 'package:flutter/material.dart';

import 'config.dart';

void main() {
  runApp(MaterialApp(
    home: AddProfileGroupScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AddProfileGroupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddProfileGroupScreen();
  }
}

class _AddProfileGroupScreen extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าตั้งค่าโปรไฟล์กลุ่ม"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "ชื่อกลุ่ม",
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top:30.0,left: 30.0),
            child: ListTile( 
            title: Text("สมาชิก"),
          ))
          
          ],
        ));
  }
}
