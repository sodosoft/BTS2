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

  var IDController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var userTelController = TextEditingController();
  var userCompanyNameController = TextEditingController();
  var userCompanyNoController = TextEditingController();
  var userCarNoController = TextEditingController();

  @override
  void initState() {

    IDController.text = LoginPage.allID;
    passwordController.text = LoginPage.allName;
    userNameController.text = LoginPage.allName;
    userTelController.text = LoginPage.allTel;
    userCompanyNameController.text = LoginPage.allComName;
    userCompanyNoController.text = LoginPage.allComNo;

    super.initState();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: (() => Navigator.pop(context))),
      backgroundColor: Colors.green,
      elevation: 1,
      title: const Text(
        '회원 정보 변경',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }



  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(12, 5, 0, 2),
                          child: TextFormField(
                            enabled: false,
                            controller: IDController,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            decoration: const InputDecoration(
                              labelText:'아이디',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 5, 0, 2),
                            child: TextField(
                              controller: passwordController,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child:ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                              ),
                              child: Text('변경'),
                              onPressed: () {
                                if(UpdateData.passwordChange(LoginPage.allID, passwordController.text))
                                {
                                  Fluttertoast.showToast(msg: '변경 성공');
                                }
                                else{
                                  Fluttertoast.showToast(msg: '변경 실패');
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}


