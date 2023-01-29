import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class endArea extends StatefulWidget {
  const endArea({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<endArea> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '하차지 기준 배차 오더',
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
                Icons.upload_outlined,
                color: Colors.grey[850],
              ),
              title: Text('하차지 목록'),
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
    );
  }
}

