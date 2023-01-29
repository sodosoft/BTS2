import 'dart:convert';

import 'package:bangtong/pages/addOrder.dart';
import 'package:bangtong/pages/setting.dart';
import 'package:bangtong/pages/weightDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:bangtong/login/login.dart';
import 'package:intl/intl.dart';

import '../../model/orderboard.dart';
import '../function/UpdateData.dart';
import '../function/displaystring.dart';
import 'addScreen.dart';
import 'editScreen.dart'; //flutter의 package를 가져오는 코드 반드시 필요

class orderING extends StatefulWidget {
  const orderING({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<orderING> {

  var userCarNoController = TextEditingController();

  Future<List<OrderData>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.orderBoard_orderYN), body: {
        'orderID': LoginPage.allID,
        'orderYN' : 'Y'
      });

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
      // appBar: AppBar(
      //   title: const Text("Generate List"),
      // ),
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
                                showDialog(
                                    context: context,
                                    builder: (ctxDialog) =>
                                        SingleChildScrollView(child: simpleDialog())
                                );
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

  Widget simpleDialog() {
    return AlertDialog(
      title: Text('배차 완료'),
      content: TextFormField(
        controller: userCarNoController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
      actions: <Widget>[
        new TextButton(
          child: new Text("확인"),
          onPressed: () {
            //
            UpdateData.confirmYNChange(LoginPage.allID, userCarNoController.text, 'Y');
            Navigator.pop(context);
          },
        ),

      ],
    );
  }
}
