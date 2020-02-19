import 'package:flutter/material.dart';
import 'package:mobile_doc/home.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: EditGroupScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class EditGroupScreen extends StatefulWidget {
  final String groupName;
  final String groupDesc;
  final String groupId;
  EditGroupScreen({Key key, this.groupName, this.groupDesc, this.groupId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditGroupScreen(this.groupName, this.groupDesc, this.groupId);
  }
}

class _EditGroupScreen extends State {
  String groupName;
  String groupDesc;
  String groupId;
  _EditGroupScreen(this.groupName, this.groupDesc, this.groupId);
  var _groupName = new TextEditingController();
  var _groupDesc = new TextEditingController();
  void click() {
    print(groupName);
    print(groupId);
    print(groupDesc);
    Map<String, String> params = Map();
    params['group_id'] = groupId;
    params['group_description'] = _groupDesc.text;
    params['group_name'] = _groupName.text;
    print(params);
    http.post('${Config.api_url}/api/editgroup', body: params).then((response) {
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _groupName.text = groupName.toString();
    _groupDesc.text = groupDesc.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าแก้ไขเอกสาร"),
        ),
        body: ListView(children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ชื่อกลุ่ม",
                contentPadding: EdgeInsets.all(10.0),
              ),
              controller: _groupName,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "รายละเอียดกลุ่ม",
                contentPadding: EdgeInsets.all(10.0),
              ),
              controller: _groupDesc,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
              child: RaisedButton(
                onPressed: click,
                color: Colors.green,
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ]));
  }
}
