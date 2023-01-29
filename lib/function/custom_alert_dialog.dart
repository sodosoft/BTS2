import 'package:bangtong/function/UpdateData.dart';
import 'package:flutter/material.dart';

import '../login/login.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.orderIndex,
  }) : super(key: key);

  final String title, description, orderIndex;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          Text(
            "${widget.title}",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text("${widget.description}"),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                // 화주한테 전화 걸기
              },
              child: Center(
                child: Text(
                  "전화 걸기",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                // 취소
                // orderYN N으로 업데이트
                UpdateData.orederYNChange(widget.orderIndex, 'N');
                // 캔슬 횟수 추가(캔슬 횟수 하루에 3번 제한)
                offDialog(LoginPage.cancelCount + 1);
                // 화면 닫음
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  "취소",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> offDialog(int cancelcount) async {
    return await showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("오더 취소",
                  style: TextStyle(color: Colors.red)),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '오더 잡기를 취소하셨습니다.' + '\n' +
                    '하루에 3번 이상 취소 하실 수 없습니다.'
                ),
                Text('(현재 취소 횟수: $cancelcount 회 입니다.)',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  // 캔슬 카운트 상승
                  UpdateData.calcelCountChange(LoginPage.allID, cancelcount);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

