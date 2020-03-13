import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_doc/edit_document.dart';
import 'add_document.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(MaterialApp(
    home: DetailDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DetailDocumentScreen extends StatefulWidget {
  final String imgPath;
  final String docName;
  final String docDesc;
  final String docObjt;
  final String docCreate;
  final String docUpdate;
  final String docId;
  DetailDocumentScreen(
      {Key key,
      this.imgPath,
      this.docName,
      this.docDesc,
      this.docCreate,
      this.docUpdate,
      this.docObjt,
      this.docId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailDocumentScreen(this.imgPath, this.docName, this.docDesc,
        this.docCreate, this.docUpdate, this.docObjt, this.docId);
  }
}

class _DetailDocumentScreen extends State {
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  String imgPath;
  String docName;
  String docDesc;
  String docObjt;
  String docCreate;
  String docUpdate;
  String docId;
  _DetailDocumentScreen(this.imgPath, this.docName, this.docDesc,
      this.docCreate, this.docUpdate, this.docObjt, this.docId);

  // final snackBar = SnackBar(content: Text());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    message = "No message.";

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
    super.initState();
  }

  sendNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(111, 'Hello, benznest.',
        'This is a your notifications. ', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  _showToast() {
    final snackBar = new SnackBar(
      content: const Text('ดาวน์โหลดสำเร็จ'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  downloadImg() async {
    print(imgPath);
    var response = await Dio().get("${Config.img_url}/" + imgPath,
        options: Options(responseType: ResponseType.bytes));
    print(response);
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data))
            .then((onValue) {
      print(onValue);
      _showToast();
      sendNotification();
    });
    // if (result) {
    // Scaffold.of(context).showSnackBar(snackBar);
    // }
    //  else {
    //   final snackBar = SnackBar(
    //       content: Text(
    //     'ดาวน์โหลดสำเร็จ',
    //     style: TextStyle(color: Colors.red[300]),
    //   ));
    //   Scaffold.of(context).showSnackBar(snackBar);
    // }
  }

  void _onImageFile() async {
    await Navigator.of(context).pop();
    print("${Config.img_url}/" + imgPath);

    try {
      var request =
          await HttpClient().getUrl(Uri.parse("${Config.img_url}/" + imgPath));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(
        '$docName',
        '$docName.jpg',
        bytes,
        '*/*',
      );
    } catch (e) {
      print('error: $e');
    }
  }

  void _onImageUrl() async {
    await Navigator.of(context).pop();
    print("${Config.img_url}/" + imgPath);

    try {
      Share.text(
          'Link to Doc',
          'ชื่อเอกสาร:$docName \n รายละเอียด : $docDesc \n แจ้งเพื่อ : $docObjt \n ${Config.img_url}/' +
              imgPath,
          'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  _shareOption() async {
    switch (await showDialog<DetailDocumentScreen>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Share to external'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _onImageFile();
                },
                child: const Text('แชร์ไฟล์'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _onImageUrl();
                },
                child: const Text('แชร์ลิงก์'),
              ),
            ],
          );
        })) {
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("รายละเอียดเอกสาร"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          Container(
            child:
                Text("ชื่อเอกสาร : $docName", style: TextStyle(fontSize: 18.0)),
            margin: EdgeInsets.only(top: 30.0),
          ),
          Container(
            child: Text("รายละเอียดเอกสาร : $docDesc",
                style: TextStyle(fontSize: 18.0)),
            margin: EdgeInsets.only(top: 30.0),
          ),
          Container(
            child:
                Text("แจ้งเพื่อ : $docObjt", style: TextStyle(fontSize: 18.0)),
            margin: EdgeInsets.only(top: 30.0),
          ),
          Container(
            child: Text(
              "วันที่สร้าง : $docCreate",
              style: TextStyle(fontSize: 16.0),
            ),
            margin: EdgeInsets.only(top: 20.0, right: 20.0),
          ),
          Container(
            child: Text(
              "วันที่แก้ไขล่าสุด $docUpdate",
              style: TextStyle(fontSize: 16.0),
            ),
            margin: EdgeInsets.only(top: 20.0, right: 20.0),
          ),
          Container(
            margin: EdgeInsets.only(top: 30.0, right: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FloatingActionButton.extended(
                        label: Text("ดาวน์โหลด"),
                        heroTag: "btn_download",
                        icon: Icon(Icons.file_download),
                        backgroundColor: Colors.blue,
                        onPressed: downloadImg,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      new FloatingActionButton.extended(
                        label: Text("แชร์"),
                        heroTag: "btn_share",
                        icon: Icon(Icons.share),
                        backgroundColor: Colors.blue,
                        onPressed: _shareOption,
                      ),
                    ],
                  )
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: FloatingActionButton.extended(
              label: Text("แก้ไข"),
              icon: Icon(Icons.edit),
              backgroundColor: Colors.blue,
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext) => EditDocumentScreen(
                          docName: docName,
                          docDesc: docDesc,
                          docId: docId,
                          docPic: imgPath,
                          docObjt: docObjt,
                        )))
              },
            ),
          ),
          Container(
            child: PhotoView(
              imageProvider: NetworkImage(
                "${Config.img_url}/" + imgPath,
              ),
              backgroundDecoration: BoxDecoration(color: Colors.white),
            ),
            margin: EdgeInsets.all(30.0),
            height: 300.0,
            width: 300.0,
          )
        ]))));
  }
}
