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
      appBar: AppBar(title: Text("หน้าข้อมูลผู้ใช้งาน"),),
      body: ListView(
      children: <Widget>[
        Container(
          child: Image.asset("images/group.png"),
          margin: EdgeInsets.only(top: 30.0,bottom: 30.0),
          width: 100.0,
          height: 100.0,
        ),
        Container(
          child: Text("ชื่อผู้ใช้งาน"),
           margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
           
        ),
        Container(
          child: Text("อีเมล"),
           margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
        )
       ],
    ));
  }
}