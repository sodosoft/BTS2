import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<setting> {
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text("third slide"), // second third 다름
      // ),
        body: Center(
            child:
            Text('설정 화면', style: TextStyle(fontSize: 40))
        )
    );
  }
}