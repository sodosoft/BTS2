import 'dart:async';

import 'package:bangtong/function/UpdateData.dart';
import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:direct_sms/direct_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../function/custom_alert_dialog.dart';
import '../function/displaystring.dart';
import '../login/login.dart';
import '../model/orderboard.dart';

class DetailPageDriver extends StatefulWidget {
  final OrderData postData;
  DetailPageDriver(this.postData,{Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(postData);
}

class _MyAppState extends State<DetailPageDriver> {
  final OrderData postData;
  _MyAppState(@required this.postData);
  Timer? _timer;
  var directSms = DirectSms();
  List<String> people = [];

  void _start() {
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      setState(() {
        offDialog(LoginPage.cancelCount.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(DisplayString.displayArea(postData.startArea) +
            " >> " +
            DisplayString.displayArea(postData.endArea)),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        height: double.maxFinite,
        child:Column(
          children:
          [
            Text('상차지: ' + postData.startArea.toString()  + '\n' +
                 '하차지: ' + postData.endArea.toString()  + '\n' +
                 '상차일시: ' + DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.parse(postData.startDateTime)) + '\n' +
                 '하차일시: ' + DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.parse(postData.endDateTime)) + '\n' +
                 '운반비: ￦' + postData.cost + "원"  + '\n' +
                 '지불방식: ' + postData.payMethod.toString()  + '\n' +
                 '차종: ' + postData.carKind.toString()  + '\n' +
                 '품목: ' + postData.product.toString()  + '\n' +
                 '등급: ' + postData.grade.toString()  + '\n' +
                 '상차방법: ' + postData.startMethod.toString()  + '\n'
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text('오더 잡기'),
                onPressed:()
                {
                  if(LoginPage.cancelCount > 3)
                  {
                    Fluttertoast.showToast(msg: '취소 제한 횟수 3회를 초과하셨습니다.' + '\n' + '익일 자정 이후 초기화 됩니다.');
                    return;
                  }
                  else
                  {
                    // 화주한테 차번호 SMS 보내기
                    _sendSms(
                      message: '오더 번호: ' + postData.orderIndex + '\n\n' +
                          '차량 번호: ' + LoginPage.allCarNo + '\n' +
                          '바로 전화 드릴테니 배차 등록 부탁드립니다.',
                      number: postData.orderTel,
                    );
                    // orderYN Y로 업데이트
                     UpdateData.orederYNChange(postData.orderIndex, 'Y');
                    // // 타이머 10분
                     _start();
                    showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          title: '지난 시간 :  $_timer',
                          description: '오더 번호: ' + postData.orderIndex + '\n' +
                              '상차지: ' + postData.startArea.toString() + '\n' +
                              '하차지: ' + postData.endArea.toString() + '\n' +
                              '상차일시: ' +
                              DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                  DateTime.parse(postData.startDateTime)) +
                              '\n' +
                              '하차일시: ' +
                              DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                  DateTime.parse(postData.endDateTime)) + '\n' +
                              '운반비: ￦' + postData.cost,
                          orderIndex: postData.orderIndex,
                          orderTel: postData.orderTel,
                        );
                      },
                    );
                  }
                }
              ),
            ),
          ],),
      ),
      //body: Text(postData.content),
    );
  }

  Future<bool> offDialog(String cancelcount) async {
    return await showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("시간 초과",
                  style: TextStyle(color: Colors.red),),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '시간이 초과되어서 오더 잡기에' + '\n' +
                  '실패하셨습니다.'
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  // 캔슬 카운트 상승
                  UpdateData.orederYNChange(postData.orderIndex, 'N');
                  UpdateData.calcelCountChange(LoginPage.allID, LoginPage.cancelCount + 1);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _sendSms({required String number, required String message}) async {
    final permission = Permission.sms.request();
    if (await permission.isGranted) {
      directSms.sendSms(message: message, phone: number);
    }
  }
}
