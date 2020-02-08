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

  bool _isError = false; // for check password
  bool _validate = false;
  String _msg = null;
  void onRegister() {
    print("onRegister");
    if (_email.text == "" ||
        _userName.text == "" ||
        _passWord.text == "" ||
        _confirmPassword.text == "" ||
        _firstName.text == "" ||
        _lastName.text == "") {
      _validate = true;
    } else if (_passWord.text != _confirmPassword.text) {
      _isError = true;
      _msg = 'รหัสผ่านไม่ตรงกัน';
    } else {
      _isError = false;
      _validate = false;
      Map<String, String> params = Map();
      params['user_username'] = _userName.text;
      params['user_password'] = _passWord.text;
      params['user_fname'] = _firstName.text;
      params['user_lname'] = _lastName.text;
      params['user_email'] = _email.text;
      print(params);
      http.post('${Config.api_url}/api/adduser', body: params).then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        bool status = resMap['success'];
        if (status == false) {
          setState(() {
            _isError = true;
            _msg = resMap['message'];
            print(_msg);
          });
        } else {
          _showDialogSuccess();
          print("DDDDDDDDDDDDDDDDDDDDDDD");
        }
      });
    }

    setState(() {});
  }

  void _showDialogSuccess() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("ลงทะเบียนสำเร็จ"),
          content: new Text("ลงทะเบียนสำเร็จ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext) => DocApp()));
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
          title: Text("หน้าลงทะเบียน"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "FirstName",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: _firstName,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Lastname",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: _lastName,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Email",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: _email,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
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
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: _passWord,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confrim Password",
                  contentPadding: EdgeInsets.all(10.0),
                  errorText: _validate ? "${Config.err_empty_str}" : null,
                ),
                controller: _confirmPassword,
              ),
            ),
            _isError
                ? Text(
                    _msg,
                    style: TextStyle(color: Colors.red),
                  )
                : Padding(
                    padding: EdgeInsets.all(0.0),
                  ),
            Container(
                margin: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
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
                ))
          ],
        ));
  }
}
