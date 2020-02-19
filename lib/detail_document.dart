import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
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

void main() {
  runApp(MaterialApp(
    home: DetailDocumentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class DetailDocumentScreen extends StatefulWidget {
  final String imgPath;
  DetailDocumentScreen({Key key, this.imgPath}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailDocumentScreen(this.imgPath);
  }
}

class _DetailDocumentScreen extends State {
  String imgPath;
  _DetailDocumentScreen(this.imgPath);

  downloadImg() async {
    print(imgPath);
    var response = await Dio().get("${Config.img_url}/" + imgPath,
        options: Options(responseType: ResponseType.bytes));
    print(response);
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
  }

  void _onImageShareButtonPressed() async {
    print("${Config.img_url}/" + imgPath);

    var request =
        await HttpClient().getUrl(Uri.parse("${Config.img_url}/" + imgPath));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
  }

  @override
  void initState() {
    super.initState();
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("หน้ารายละเอียดเอกสาร"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          Container(
            child: Text("รายละเอียดเอกสาร", style: TextStyle(fontSize: 18.0)),
            margin: EdgeInsets.only(top: 30.0),
          ),
          Container(
            child: Text(
              "วันที่อัปโหลด",
              style: TextStyle(fontSize: 16.0),
            ),
            margin: EdgeInsets.only(top: 20.0, right: 20.0),
          ),
          Container(
            child: Text(
              "วันที่แก้ไขล่าสุด",
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
                        onPressed: _onImageShareButtonPressed,
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
                    builder: (BuildContext) => EditDocumentScreen()))
              },
            ),
          ),
          Container(
            child: Image.network(
              "${Config.img_url}/" + imgPath,
              loadingBuilder: (context, child, progress) {
                return progress == null ? child : LinearProgressIndicator();
              },
            ),
            margin: EdgeInsets.all(30.0),
            height: 300.0,
            width: 300.0,
          )
        ]))));
  }
}
