import 'package:flutter/material.dart';
import 'package:mobile_doc/register.dart';
import 'package:mobile_doc/doc_category.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'doc_category.dart';
import 'group.dart';

void main() {
  runApp(MaterialApp(
    home: DocApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class DocApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DocApp();
  }
}

class _DocApp extends State {
  TextEditingController _userName = TextEditingController();
  TextEditingController _passWord = TextEditingController();
  bool _validate = false;
  // int get userId => null;
  String userId;
  String fname;
  String lname;
  String password;
  String username;
  String email;
  void onLogin() {
    print("onLogin");
    Map<String, String> params = Map();
    params['user_username'] = _userName.text.trim();
    params['user_password'] = _passWord.text.trim();
    if (_userName.text.trim() == "" || _passWord.text.trim() == "") {
      _validate = true;
      setState(() {});
    } else {
      _validate = false;
      http.post('${Config.api_url}/api/login', body: params).then((response) {
        Map resMap = jsonDecode(response.body) as Map;
        bool status = resMap['success'];
        if (status == true) {
          for (var items in resMap['body']) {
            userId = items['user_id'].toString();
            fname = items["user_fname"];
            lname = items["user_lname"];
            email = items["user_email"];
            password = items["user_password"];
            username = items["user_username"];
          }
          print("Login Succeeded");
          print(resMap['body']);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext) => GroupScreen(
                    userId: userId,
                    fname: fname,
                    lname: lname,
                    email: email,
                    password: password,
                    username: username,
                  )));
        } else {
          print("Login Failed");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Image.asset("images/logo.png"),
          width: 300.0,
          height: 300.0,
          padding: EdgeInsets.all(35.0),
        ),
        // Center(
        //   child: Text("Log-in to myApp", style: TextStyle(fontSize: 16.0)),
        // ),
        Container(
          margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Username",
              contentPadding: EdgeInsets.all(10.0),
              errorText: _validate ? "${Config.err_empty_str}" : null,
            ),
            controller: _userName,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Password",
                contentPadding: EdgeInsets.all(10.0),
                errorText: _validate ? "${Config.err_empty_str}" : null),
            controller: _passWord,
            obscureText: true,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
          child: RaisedButton(
            onPressed: onLogin,
            color: Colors.blue,
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Log-in',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 10.0),
            child: RaisedButton(
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext) => RegisterScreen()))
              },
              color: Colors.green,
              padding: EdgeInsets.all(15.0),
              child: Text('Register', style: TextStyle(color: Colors.white)),
            ))
      ],
    ));
  }
}
