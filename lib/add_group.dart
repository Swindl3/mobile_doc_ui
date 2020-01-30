import 'package:flutter/material.dart';
import 'package:mobile_doc/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'config.dart';

void main() {
  runApp(MaterialApp(
    home: AddGroupScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AddGroupScreen extends StatefulWidget {
 
 
  @override
  State<StatefulWidget> createState() {
    return _AddGroupScreen();
  }
}

class _AddGroupScreen extends State {
  TextEditingController _name = TextEditingController();
  TextEditingController _detail = TextEditingController();
  void confirmAddgroup() {
        Map<String, dynamic> param = Map();
    param['group_name'] = _name.text;
    param['group_description'] = _detail.text;

    http.post("${Config.api_url}/api/addgroup", body: param).then((response) {
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
          title: new Text("เพิ่มกลุ่มสำเร็จ"),
          content: new Text("เพิ่มกลุ่มสำเร็จ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()));
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("หน้าเพิ่มกลุ่ม"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "ชื่อกลุ่ม", contentPadding: EdgeInsets.all(10.0)),
                  controller: _name,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "รายละเอียดกลุ่ม",
                  contentPadding: EdgeInsets.all(10.0)),
                  controller: _detail,
            ),
          ),
          Container(
          
            margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
            child: RaisedButton(
              onPressed: confirmAddgroup,
              color: Colors.green,
              padding: EdgeInsets.all(15.0),
              child: Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white),
                
              ),
            ),
          )
        ],
      ),
    );
  }
}
