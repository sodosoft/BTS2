import 'dart:convert';

import 'package:bangtong/api/api.dart';
import 'package:bangtong/pages/DetailDriver.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<OrderData> boardList = [];

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
    try {
      setState(() {
        if(!boardList.isEmpty) {
          boardList.clear();
        }
      });

        var respone = await http.post(Uri.parse(API.DriverOrder_all));

        if (respone.statusCode == 200) {
          final result = utf8.decode(respone.bodyBytes);
          List<dynamic> json = jsonDecode(result);

          if(boardList.isEmpty) {
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
          }

          final data = boardList;

          setState(() {
            this.boardList = data;
          });

          return boardList;
        } else {
          Fluttertoast.showToast(msg: '데이터 로딩 실패!');
          return null;
        }
      }
       catch (e)
     {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
     }
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
                if(scaffoldKey.currentState!.isDrawerOpen){
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                  refresh();
                }
                else{
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
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
                                            DetailPageDriver(snapshot.data[index])));
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


