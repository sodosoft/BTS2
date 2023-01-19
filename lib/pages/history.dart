import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/login/login.dart';
import 'package:bangtong/model/orderboard.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:http/http.dart' as http;

import '../../api/api.dart';
import '../function/displaystring.dart';

class third extends StatefulWidget {
  const third({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<third> {
  int _itemCnt = 0;
  int _subTotal = 0;

  Future<List<OrderData_driver>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.order_HISTORY), body: {
        'orderID': LoginPage.allID,
      });

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<OrderData_driver> boardList = [];

        for (var item in json.reversed) {
          OrderData_driver boardData = OrderData_driver(
              item['orderID'],
              item['startArea'],
              item['endArea'],
              item['cost'],
              item['startDateTime'],
              item['endDateTime'],
              item['steelCode'],
              item['orderTel'],
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

  @override
  void initState() {
    super.initState();
  }

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text("Generate List"),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        actions: [
          IconButton(
              tooltip: "검색",
              onPressed: () {
                //검색 조건 창 띄움
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
              future: _getPost(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _itemCnt = snapshot.data.length;
                  _subTotal = CostAdd(snapshot.data);

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
                            subtitle: Text(snapshot.data[index].startDateTime +
                                '\n' +
                                snapshot.data[index].cost),
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
            SizedBox(
              height: 15,
            ),
            Text('총 ' + '$_itemCnt' + '건'),
            SizedBox(
              height: 5,
            ),
            Text('합계 금액 ' + '$_subTotal' + '원'),
          ],
        ),
      ),
    );
  }
}

int CostAdd(data) {
  int _add = 0;

  for (int i = 0; i > data.length; i++) {
    _add += int.parse(data[i].cost);
  }

  return _add;
}

class DetailPage extends StatelessWidget {
  final OrderData_driver postData;

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
        child:
            Text('일시:' + postData.endDateTime + '\n' + '운반비' + postData.cost),
      ),
      //body: Text(postData.content),
    );
  }
}
