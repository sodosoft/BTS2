import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class steeltArea extends StatefulWidget {
  const steeltArea({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<steeltArea> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '제강사 기준 배차 오더',
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
                Icons.settings,
                color: Colors.grey[850],
              ),
              title: Text('제강사 목록'),
            ),
            ListTile(
              title: Text('전체'),
              onTap: (){
                Fluttertoast.showToast(msg: '전체 제강사');
              },
            ),
            ListTile(
              title: Text('동국제강(인천)'),
              onTap: (){
                Fluttertoast.showToast(msg: '동국제강(인천)');
              },
            ),
            ListTile(
              title: Text('현대제철(인천)'),
              onTap: (){
                Fluttertoast.showToast(msg: '현대제철(인천)');
              },
            ),
            ListTile(
              title: Text('세아베스틸'),
              onTap: (){
                Fluttertoast.showToast(msg: '세아베스틸');
              },
            ),
            ListTile(
              title: Text('환영철강'),
              onTap: (){
                Fluttertoast.showToast(msg: '환영철강');
              },
            ),
            ListTile(
              title: Text('한국특수형강'),
              onTap: (){
                Fluttertoast.showToast(msg: '한국특수형강');
              },
            ),
            ListTile(
              title: Text('대한제강'),
              onTap: (){
                Fluttertoast.showToast(msg: '대한제강');
              },
            ),
            ListTile(
              title: Text('포스코'),
              onTap: (){
                Fluttertoast.showToast(msg: '포스코');
              },
            ),
            ListTile(
              title: Text('YK스틸'),
              onTap: (){
                Fluttertoast.showToast(msg: 'YK스틸');
              },
            ),
          ],
        ),
      ),
    );
  }
}

