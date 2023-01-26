import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bangtong/login/signup.dart';
import 'package:bangtong/pages/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bangtong/pages/main_screen_driver.dart';

import '../api/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static late String allCarNo;
  static late String allID;
  static late String allName;
  static late String allTel;
  static late int cancelCount;
  static late String paymentDay;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  var idController = TextEditingController();
  var passwordController = TextEditingController();

  userLogin() async {
    try {
      var res = await http.post(Uri.parse(API.login), body: {
        'userID': idController.text.trim(),
        'userPassword': passwordController.text.trim()
      });

      if (res.statusCode == 200) {
        var resLogin = jsonDecode(res.body);
        if (resLogin['success'] == true) {
          Fluttertoast.showToast(msg: '로그인 성공');
          // User userInfo = User.fromJson(resLogin['userName']);
          // await RememberUser.saveRememberUserInfo(userInfo);

          String userName = resLogin['userName'].toString();
          String userID = resLogin['userID'].toString();
          String userTel = resLogin['userTel'].toString();
          String paymentYN = resLogin['payment'].toString();
          String paymentDay = resLogin['paymentDay'].toString();
          int cancelCount = resLogin['cancelCount'];

          LoginPage.allID = userID;
          LoginPage.allName = userName;
          LoginPage.allTel = userTel;
          LoginPage.paymentDay = paymentDay;
          LoginPage.cancelCount = cancelCount;

          String userGrade = resLogin['userGrade'].toString();

          if(paymentYN == 'Y')
          {
            if (userGrade == 'D') {
              LoginPage.allCarNo = resLogin['userCarNo'].toString();
              // 차주 전용 화면
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreenDriver()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            }

            setState(() {
              idController.clear();
              passwordController.clear();
            });
          }
          else          //미결제
          {
            Fluttertoast.showToast(msg: '결제 부탁 드립니다!');
            //데모 화면
          }
        } else {
          Fluttertoast.showToast(msg: '아이디와 비밀 번호를 변경해주세요!');
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/truck.gif'),
                  width: 170.0,
                  height: 190.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sodo Soft',
                  style: GoogleFonts.bebasNeue(fontSize: 26.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '방통 배차 시스템',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
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
                              controller: idController,
                              validator: (val) =>
                                  val == "" ? "아이디를 입력하세요!" : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '아이디'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                  val == "" ? "비밀 번호를 입력하세요!" : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: '비밀번호'),
                            ),
                          ),
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
                    if (formKey.currentState!.validate()) {
                      userLogin();
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            '로그인',
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
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('회원이 아니신가요?'),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage())),
                      child: Text(
                        ' 회원 가입!',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}