import 'dart:convert';
import 'package:bangtong/function/UpdateData.dart';
import 'package:flutter/material.dart';
import 'package:bangtong/api/api.dart';
import 'package:bangtong/login/login.dart';
import 'package:bangtong/model/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_test.dart';
import '../pages/policy.dart';
import '../pages/w1.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl/intl.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SignupPageState();
}

class _SignupPageState extends State<Setting> {

  var formKey = GlobalKey<FormState>();

  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var userTelController = TextEditingController();
  var userCompanyNameController = TextEditingController();
  var userCompanyNoController = TextEditingController();
  var userCarNoController = TextEditingController();

  @override
  void initState() {

    passwordController.text = LoginPage.allName;
    userNameController.text = LoginPage.allName;
    userTelController.text = LoginPage.allTel;
    userCompanyNameController.text = LoginPage.allComName;
    userCompanyNoController.text = LoginPage.allComNo;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
        children: <Widget>[
            SizedBox(
              height: 20,
            ),
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
                  child: Text(LoginPage.allID),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
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
                        controller: userNameController,
                        validator: (val) =>
                        val == "" ? "이름을 입력하세요!" : null,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: '이름'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: Text('변경'),
                  onPressed: () {

                    if(UpdateData.passwordChange(LoginPage.allID, userNameController.text))
                    {
                      Fluttertoast.showToast(msg: '변경 성공!');
                    }
                    else{
                      Fluttertoast.showToast(msg: '변경 실패!');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
    );
  }
}


