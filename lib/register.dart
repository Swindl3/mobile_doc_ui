import 'package:flutter/material.dart';
import 'package:mobile_doc/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
void main() {
  runApp(MaterialApp(
    home: RegisterScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends State {
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _passWord = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  bool _isError = false;
  String _msg = null;
  void onRegister(){
    print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
    if (_passWord.text != _confirmPassword.text) {
      _isError = true;
      _msg = 'รหัสผ่านไม่ตรงกัน';
    } else {
      _isError = false;
      Map<String, String> params = Map();
      params['user_username'] = _userName.text;
      params['user_password'] = _passWord.text;
      params['user_fname'] = _firstName.text;
      params['user_lname'] = _lastName.text;
      params['user_email'] = _email.text;
      print(params);
      http
          .post('${Config.api_url}/api/adduser', body: params)
          .then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        bool status = resMap['success'];
        if (status != true) {
          setState(() {
            _isError = true;
            _msg = resMap['message'];
            print(_msg);
          });
        } else {
          // _showDialog();
          print("DDDDDDDDDDDDDDDDDDDDDDD");
        }
      });
    }

    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("หน้าลงทะเบียน"),),
      body: ListView(
      children: <Widget>[
        _isError
              ? Text(
                  _msg,
                  style: TextStyle(color: Colors.red),
                )
              : Padding(
                  padding: EdgeInsets.all(0.0),
                ),
        Container(
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
          child: TextField(
          decoration: InputDecoration(
              hintText: "FirstName", contentPadding: EdgeInsets.all(10.0)),
              controller: _firstName,
        ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
          child: TextField(
          decoration: InputDecoration(
              hintText: "Lastname", contentPadding: EdgeInsets.all(10.0)),
              controller: _lastName,
        ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
          child: TextField(
          decoration: InputDecoration(
              hintText: "Email", contentPadding: EdgeInsets.all(10.0)),
              controller: _email,
        ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
          child: TextField(
          decoration: InputDecoration(
              hintText: "Username", contentPadding: EdgeInsets.all(10.0)),
              controller: _userName,
        ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
          child: TextField(
          decoration: InputDecoration(
              hintText: "Password", contentPadding: EdgeInsets.all(10.0)),
              controller: _passWord,
        ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
          child: TextField(
          decoration: InputDecoration(
              hintText: "Confrim Password", contentPadding: EdgeInsets.all(10.0)),
              controller: _confirmPassword,
        ),
        ),
       Container(
          margin: EdgeInsets.only(left: 60.0,right: 60.0,top: 30.0),
          child: RaisedButton(
          onPressed: onRegister,
          // () => {
          //   Navigator.of(context).push(
          //       MaterialPageRoute(builder: (BuildContext) => DocApp()))
          // },
          color: Colors.green,
          padding: EdgeInsets.all(15.0),
          child: Text(
            'ยืนยัน',
            style: TextStyle(color: Colors.white),
          ),
        )
        )
      ],
    ));
  }
}
