import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요


class four extends StatefulWidget {
  const four({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<four> {
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text("third slide"), // second third 다름
      // ),
        body: Center(child: Text('상담 문의',style: TextStyle(fontSize: 40))) //second third 다름
    );
  }
}