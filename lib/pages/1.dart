import 'dart:convert';

import 'package:bangtong/pages/addOrder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:bangtong/login/login.dart';

import '../../model/orderboard.dart';
import '../function/displaystring.dart';
import 'addScreen.dart'; //flutter의 package를 가져오는 코드 반드시 필요

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<first> {
  Future<List<OrderData>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.orderBoard), body: {
        'orderID': LoginPage.allID,
      });

      if(respone.statusCode== 200)
      {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<OrderData> boardList = [];

        for(var item in json.reversed)
        {
          OrderData boardData = OrderData(item['orderID'], item['orderIndex'], item['startArea'], item['endArea'],
              item['cost'], item['payMethod'], item['carKind'], item['product'],
              item['grade'], item['startDateTime'], item['endDateTime'], item['end1'],
              item['bottom'], item['startMethod'], item['steelCode'], item['orderYN'],
              item['confirmYN'], item['orderTel'], item['companyName'], item['userCarNo']
          );
          boardList.add(boardData);
        }

        return boardList;
      }
      else
      {
        Fluttertoast.showToast(msg: '데이터 로딩 실패!');
        return null;
      }
    } catch (e) {
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
      // appBar: AppBar(
      //   title: const Text("Generate List"),
      // ),
      body: Container(
        child: FutureBuilder(
          future: _getPost(),
          builder: (context, AsyncSnapshot snapshot) {

            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(DisplayString.displayArea(snapshot.data[index].startArea) + " >> " + DisplayString.displayArea(snapshot.data[index].endArea)),
                        subtitle: Text(snapshot.data[index].startDateTime +
                            '\n' + snapshot.data[index].cost),
                        isThreeLine: true,
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             DetailPage(snapshot.data[index])));
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
      floatingActionButton: FloatingActionButton(
        tooltip: "배차 등록",
        onPressed: () async {
          final reuslt = await Navigator.push(
              // context, MaterialPageRoute(builder: ((context) => AddScreen())));
              context, MaterialPageRoute(builder: ((context) => AddOrder())));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}