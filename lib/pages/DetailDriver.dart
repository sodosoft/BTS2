import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';

import '../function/displaystring.dart';
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

  bool _visibility = false;

  void _show() {
    setState(() {
      _visibility = true;
    });
  }
  void _hide() {
    setState(() {
      _visibility = false;
    });
  }

  //DetailPageDriver(this.postData); // 생성자를 통해서 입력변수 받기

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
                '상차방법: ' + postData.startMethod.toString()  + '\n' +
                '차량번호: ' + postData.userCarNo.toString()
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text('오더 잡기'),
                onPressed:
                // 화주한테 차번호 SMS 보내기
                // orderYN Y로 업데이트
                // 타이머 10분
                    () => {_visibility? _hide() : _show()},
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _visibility,
              child:
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(

                  child: Text('전화 걸기'),
                  onPressed: (){
                    // 화주한테 전화 걸기

                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _visibility,
              child:
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(

                  child: Text('취소'),
                  onPressed: (){
                    // 취소
                    // orderYN N으로 업데이트
                    // 캔슬 횟수 추가(캔슬 횟수 하루에 3번 제한)
                    // 화면 닫음
                  },
                ),
              ),
            ),
          ],),
      ),
      //body: Text(postData.content),
    );
  }
}
