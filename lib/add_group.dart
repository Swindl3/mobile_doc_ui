import 'package:flutter/material.dart';
import 'package:mobile_doc/doc_category.dart';
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
  final String groupUserId;
  final String userId;
  AddGroupScreen({Key key, this.groupUserId,this.userId}):super(key :key);
  @override
  State<StatefulWidget> createState() {
    return _AddGroupScreen(this.groupUserId,this.userId);
  }
}

class _AddGroupScreen extends State {
  String groupUserId;
  String userId;
  _AddGroupScreen(this.groupUserId,this.userId);
  TextEditingController _name = TextEditingController();
  TextEditingController _detail = TextEditingController();
  bool _validate = false;
  void confirmAddgroup() {

    Map<String, dynamic> param = Map();
    param['group_name'] = _name.text;
    param['group_description'] = _detail.text;
    param['groupuser_id'] = groupUserId;
    param['user_id'] = userId;

    print(param);
    if (_name.text == "" || _detail.text == "") {
      _validate = true;
    } else {
      _validate = false;
      http.post("${Config.api_url}/api/addgroup", body: param).then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        String status = resMap['status'];
        if (status == "success") {
          setState(() {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            _showDialogSuccess();
          });
        } else {}
      });
    }
  }

  void _showDialogSuccess() {
    // Navigator.of(context).pop();
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
                     Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(groupUserId: groupUserId,userId: userId,)));
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
        title: Text("เพิ่มประเภทเอกสาร"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "ชื่อประเภทเอกสาร", contentPadding: EdgeInsets.all(10.0),
                  errorText:_validate ? "${Config.err_empty_str}" : null),
              controller: _name,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "รายละเอียดประเภทเกสาร",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null),
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
