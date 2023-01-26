import 'dart:io';

import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:share_plus/share_plus.dart';

class weightDataScreen extends StatefulWidget {
  final String orderTel;
  weightDataScreen(this.orderTel,{Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<weightDataScreen> {
  File? _image;
  final picker = ImagePicker();
  String orderTel = '';
  String? _message;
  List<String> people = [];

  String _path = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderTel = widget.orderTel;
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _path = image!.path;
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
              onPressed: (() => Navigator.pop(context))),
          backgroundColor: Colors.green,
          elevation: 1,
          title: const Text(
            '계근 사진 보내기',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            showImage(),
            SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 카메라 촬영 버튼
                FloatingActionButton(
                  child: Icon(Icons.add_a_photo),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  child: Icon(Icons.wallpaper),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () async {
                Clipboard.setData(ClipboardData(text: orderTel));
                await Share.shareFiles([_path],text: '계근 사진');
                //_send();
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        '공유하기',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: "SMS TEST",
        recipients: recipients,
        sendDirect: true,
      );
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  void _send() {
    if (people.isEmpty) {
      setState(() => _message = '적어도 1명의 연락처 또는 메세지가 필요합니다.');
    } else {
      _sendSMS(people);
    }
  }
}



