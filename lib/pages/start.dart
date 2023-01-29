import 'dart:convert';

import 'package:bangtong/api/api.dart';
import 'package:bangtong/pages/editScreen.dart';
import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';

import '../function/displaystring.dart';
import '../model/orderboard.dart';
import 'package:http/http.dart' as http;

class startArea extends StatefulWidget {
  const startArea({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<startArea> {

  Future<List<OrderData>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.DriverOrder_all));

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<OrderData> boardList = [];

        for (var item in json.reversed) {
          OrderData boardData = OrderData(
              item['orderID'],
              item['orderIndex'],
              item['startArea'],
              item['endArea'],
              item['cost'],
              item['payMethod'],
              item['carKind'],
              item['product'],
              item['grade'],
              item['startDateTime'],
              item['endDateTime'],
              item['end1'],
              item['bottom'],
              item['startMethod'],
              item['steelCode'],
              item['orderYN'],
              item['confirmYN'],
              item['orderTel'],
              item['companyName'],
              item['userCarNo']);
          boardList.add(boardData);
        }

        return boardList;
      } else {
        Fluttertoast.showToast(msg: '데이터 로딩 실패!');
        return null;
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future refresh() async {
    _getPost();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '상차지 기준 배차 오더',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.close))
          ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.download_outlined,
                color: Colors.grey[850],
              ),
              title: Text('상차지 목록'),
            ),
            ListTile(
              title: Text('전체'),
              onTap: (){
                Fluttertoast.showToast(msg: '전체 지역');

              },
            ),
            ListTile(
              title: Text('서울'),
              onTap: (){
                Fluttertoast.showToast(msg: '서울 지역');
              },
            ),
            ListTile(
              title: Text('인천/경기'),
              onTap: (){
                Fluttertoast.showToast(msg: '인천/경기 지역');
              },
            ),
            ListTile(
              title: Text('강원'),
              onTap: (){
                Fluttertoast.showToast(msg: '강원 지역');
              },
            ),
            ListTile(
              title: Text('대전/충남'),
              onTap: (){
                Fluttertoast.showToast(msg: '대전/충남 지역');
              },
            ),
            ListTile(
              title: Text('충북'),
              onTap: (){
                Fluttertoast.showToast(msg: '충북 지역');
              },
            ),
            ListTile(
              title: Text('광주/전남'),
              onTap: (){
                Fluttertoast.showToast(msg: '광주/전남 지역');
              },
            ),
            ListTile(
              title: Text('전북'),
              onTap: (){
                Fluttertoast.showToast(msg: '전북 지역');
              },
            ),
            ListTile(
              title: Text('부산/경남'),
              onTap: (){
                Fluttertoast.showToast(msg: '부산/경남 지역');
              },
            ),
            ListTile(
              title: Text('대구/경북'),
              onTap: (){
                Fluttertoast.showToast(msg: '대구/경북 지역');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: FutureBuilder(
                future: _getPost(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(DisplayString.displayArea(
                                  snapshot.data[index].startArea) +
                                  " >> " +
                                  DisplayString.displayArea(
                                      snapshot.data[index].endArea)),
                              subtitle: Text('상차일시: ' +
                                  DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                      DateTime.parse(
                                          snapshot.data[index].startDateTime)) +
                                  '\n' +
                                  '하차일시: ' +
                                  DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                      DateTime.parse(
                                          snapshot.data[index].endDateTime)) +
                                  '\n' +
                                  '운반비: ￦' +
                                  snapshot.data[index].cost +
                                  "원"),
                              isThreeLine: true,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(snapshot.data[index])));
                              },
                            ),
                          );
                        });
                  } else {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final OrderData postData;
  bool _visble = false;

  DetailPage(this.postData); // 생성자를 통해서 입력변수 받기

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
                onPressed: (){
                  // 화주한테 차번호 SMS 보내기
                  // orderYN Y로 업데이트
                  // 타이머 10분
                  _visble = true;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _visble,
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
              visible: _visble,
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

