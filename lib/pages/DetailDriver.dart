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

  var directSms = DirectSms();
  List<String> people = [];

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

                    showDialog(
                      barrierColor: Colors.black26,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          title: '오더 잡기',
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

  _sendSms({required String number, required String message}) async {
    final permission = Permission.sms.request();
    if (await permission.isGranted) {
      directSms.sendSms(message: message, phone: number);
    }
  }
}
