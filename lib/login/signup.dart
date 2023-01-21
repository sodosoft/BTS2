import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bangtong/api/api.dart';
import 'package:bangtong/login/login.dart';
import 'package:bangtong/model/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_test.dart';
import '../pages/w1.dart';
import '../pages/w2.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class SteelCode {
  final String id;
  final String name;

  SteelCode({
    required this.id,
    required this.name,
  });
}

class _SignupPageState extends State<SignupPage> {
  static List<SteelCode> _steelCode = [
    SteelCode(id: "DI", name: "동국제강"),
    SteelCode(id: "HI", name: "현대제철"),
    SteelCode(id: "SA", name: "세아베스틸"),
    SteelCode(id: "HY", name: "환영철강"),
    SteelCode(id: "HK", name: "한국특수형강"),
    SteelCode(id: "DE", name: "대한제강"),
    SteelCode(id: "PO", name: "포스코"),
    SteelCode(id: "YK", name: "YK스틸")
  ];
  final _items = _steelCode
      .map((steelcode) => MultiSelectItem<SteelCode>(steelcode, steelcode.name))
      .toList();
  List<SteelCode> _selectedSteelcode = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _selectedSteelcode = _steelCode;
    super.initState();
  }

  var formKey = GlobalKey<FormState>();

  var userIDController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var userTelController = TextEditingController();
  var userGradeController = TextEditingController();
  var userCompanyNameController = TextEditingController();
  var userCompanyNoController = TextEditingController();
  var userCarNoController = TextEditingController();

  var steelCodeController = TextEditingController();

  var introducerController = TextEditingController();

  String _selectedCategory = '화주';
  List<SteelCode> _selectedSteelCode = [];

  bool _ischecked1 = false;
  bool _ischecked2 = false;

  checkUserEmail() async {
    try {
      if (_ischecked1 && _ischecked2) {
        var response = await http.post(Uri.parse(API.validateID),
            body: {'userID': userIDController.text.trim()});

        if (response.statusCode == 200) {
          String jsonData = response.body;

          var responseBody = jsonDecode(jsonData);

          if (responseBody['existEmail'] == true) {
            Fluttertoast.showToast(
              msg: "이미 가입된 ID 입니다. 다른 ID로 가입 부탁 드립니다.",
            );
          } else {
            saveInfo();
            //saveInfo_test();
          }
        } else {
          Fluttertoast.showToast(msg: "약관에 동의 하십시오");
          return;
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo_test() async {
    User_test userModel = User_test(userIDController.text.trim(),
        userNameController.text.trim(), passwordController.text.trim());

    try {
      var res =
          await http.post(Uri.parse(API.signup_test), body: userModel.toJson());

      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: '회원 가입 성공');
          setState(() {
            userIDController.clear();
            passwordController.clear();
            userNameController.clear();
            userTelController.clear();

            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: '회원 가입 실패, 확인 후 다시 시도해주세요.');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo() async {
    String strGrade = '';
    String strSteelCode = '';

    if (_selectedCategory == '화주') {
      strGrade = 'S';
    } else if (_selectedCategory == '차주') {
      strGrade = 'D';
    } else {
      strGrade = 'S';
    }

    // if (_selectedSteelCode.length > 1) {
    //   strSteelCode = splitSteelCode(_selectedSteelCode);
    // } else {
    //   strSteelCode = _selectedSteelCode[0].id.toString();
    // }

    DateTime now = DateTime.now();

    var currentDay = new DateTime(now.year, now.month, now.day);
    var currentTime =
        new DateTime(now.year, now.month, now.day, now.hour, now.minute);

    User userModel = User(
        userIDController.text.trim(),
        passwordController.text.trim(),
        userNameController.text.trim(),
        userTelController.text.trim(),
        strGrade,
        userCompanyNameController.text.trim(),
        userCompanyNoController.text.trim(),
        userCarNoController.text.trim(),
        '2023-02-22', //가입 시간
        '0',
        0, //codeCount
        0, //cancelCount
        'Y', //loginFlag
        'Y', //payment
        '2023-02-22', //paymentDay
        'SODO', // introducerController.text.trim(),
        currentTime.toString(), //loginTime(현재 접속)
        'DE');

    try {
      var res =
          await http.post(Uri.parse(API.register), body: userModel.toJson());

      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: '회원 가입 성공');
          setState(() {
            userIDController.clear();
            passwordController.clear();
            userNameController.clear();
            userTelController.clear();
            userCompanyNameController.clear();
            userCompanyNoController.clear();
            userCarNoController.clear();
            _selectedCategory = '화주';
            _ischecked1 = false;
            _ischecked2 = false;

            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: '회원 가입 실패, 확인 후 다시 시도해주세요.');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text("회원 가입"),
      // ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Test
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: DropdownButton(
                                hint: Text('등급'),
                                isExpanded: true,
                                items: ['화주', '차주', '영업사원']
                                    .map((item) => DropdownMenuItem(
                                          child: Text(item),
                                          value: item,
                                        ))
                                    .toList(),
                                value: _selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value.toString();
                                  });
                                }),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: userNameController,
                              validator: (val) =>
                                  val == "" ? "이름을 입력하세요!" : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '이름'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: userIDController,
                              validator: (val) =>
                                  val == "" ? "아이디를 입력하세요!" : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: 'ID'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (val) =>
                                  val == "" ? "비밀번호를 입력하세요!" : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '비밀번호'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: userTelController,
                              validator: (val) =>
                                  val == "" ? "연락처를 입력하세요!" : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '연락처'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // test

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: userCompanyNameController,
                              validator: (val) =>
                                  val == "" ? "소속 회사명을 입력하세요!" : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '소속 회사명'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              enabled: _selectedCategory != '영업사원',
                              controller: userCompanyNoController,
                              validator: (val) =>
                                  val == "" ? "사업자 번호를 입력하세요!" : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '사업자 번호'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              enabled: _selectedCategory == '차주',
                              controller: userCarNoController,
                              validator: (val) =>
                                  val == "" ? "차량 번호를 입력하세요!" : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '차량 번호'),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Container(
                      //     // decoration: BoxDecoration(
                      //     //   color: Colors.grey[200],
                      //     //   border: Border.all(color: Colors.white),
                      //     //   borderRadius: BorderRadius.circular(12),
                      //     // ),
                      //     // child: Padding(
                      //     //   padding: const EdgeInsets.only(left: 20.0),
                      //     child: MultiSelectDialogField(
                      //       searchHint: '차주분들만 입력하세요',
                      //       // validator: (val) =>
                      //       // val == "" ? "제강사를 추가하세요!" : null,
                      //       items: _items,
                      //       title: Text("제강사 목록(다중 선택 가능)"),
                      //       selectedColor: Colors.blue,
                      //       // decoration: BoxDecoration(
                      //       //   color: Colors.blue.withOpacity(0.1),
                      //       //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      //       //   border: Border.all(
                      //       //     color: Colors.blue,
                      //       //     width: 2,
                      //       //   ),
                      //       // ),
                      //       buttonIcon: Icon(
                      //         Icons.arrow_drop_down_outlined,
                      //         color: Colors.blue,
                      //       ),
                      //       buttonText: Text(
                      //         "제강사 목록(차주분들만 입력하세요)",
                      //         style: TextStyle(
                      //           // color: Colors.blue[800],
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //       onConfirm: (results) {
                      //         _selectedSteelCode = results;
                      //       },
                      //       cancelText: Text("취소"),
                      //       confirmText: Text('확인'),
                      //
                      //     ),
                      //   ),
                      //   //),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('[필수]서비스 이용 약관 '),
                            Transform.scale(
                              scale: 1.0,
                              child: Checkbox(
                                activeColor: Colors.white,
                                checkColor: Colors.red,
                                value: _ischecked1,
                                onChanged: (value) {
                                  setState(() {
                                    _ischecked1 = value!;

                                    if (value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WebView1()));
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('[필수]개인 정보 취급 방침 '),
                            Transform.scale(
                              scale: 1.0,
                              child: Checkbox(
                                activeColor: Colors.white,
                                checkColor: Colors.red,
                                value: _ischecked2,
                                onChanged: (value) {
                                  setState(() {
                                    _ischecked2 = value!;

                                    if (value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WebView2()));
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if( _selectedCategory == '차주') {
                            if (formKey.currentState!.validate()) {
                              checkUserEmail();
                            }
                          }
                          else
                          {
                            checkUserEmail();
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  '가입하기',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('이미 가입하셨나요?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              ' 로그인 페이지로 돌아가기!',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String splitSteelCode(List<SteelCode> selectedSteelCode) {
    String strReturn = '';

    for (int i = 0; i < selectedSteelCode.length; i++) {
      strReturn += selectedSteelCode[i].id + ' ';
    }

    return strReturn;
  }
}
