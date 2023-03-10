import 'dart:async';
import 'dart:convert';
import 'package:bangtong/function/UpdateData.dart';
import 'package:flutter/material.dart';
import 'package:bangtong/api/api.dart';
import 'package:bangtong/login/login.dart';
import 'package:bangtong/model/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../function/loginUpdate.dart';
import '../login/loginScreen.dart';
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
  var userTelController = TextEditingController();
  var userCompanyNameController = TextEditingController();
  var userCompanyNoController = TextEditingController();
  var userCarNoController = TextEditingController();

  @override
  void initState() {
    IDController.text = LoginScreen.allID + ' & ' + LoginScreen.allName;
    passwordController.text = LoginScreen.allPW;
    userTelController.text = LoginScreen.allTel;
    userCompanyNameController.text = LoginScreen.allComName;
    userCompanyNoController.text = LoginScreen.allComNo;
    userCarNoController.text = LoginScreen.allCarNo;

    super.initState();
  }

  @override
  void dispose() {
    IDController.dispose();
    passwordController.dispose();
    userTelController.dispose();
    userCompanyNameController.dispose();
    userCompanyNoController.dispose();
    userCarNoController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: (){
            offDialog();
          }),
      backgroundColor: Colors.green,
      elevation: 1,
      title: const Text(
        '?????? ?????? ??????',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 5, 0, 2),
                      child: TextFormField(
                        enabled: false,
                        controller: IDController,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: '????????? & ??????',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                          child: TextFormField(
                            controller: passwordController,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                            decoration: const InputDecoration(
                              labelText: '????????????',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Container(
                      width: 100,
                      child:
                        ElevatedButton(
                            onPressed: () {
                              if (UpdateData.passwordChange(
                                  LoginScreen.allID, passwordController.text))
                              {
                                Fluttertoast.showToast(msg: '?????? ??????');
                              } else {
                                Fluttertoast.showToast(msg: '?????? ??????');
                              }
                            },
                            child: Text('??????'),
                        ) ,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                          child: TextFormField(
                            controller: userTelController,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                            decoration: const InputDecoration(
                              labelText: '????????????',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Container(
                      width: 100,
                      child:
                      ElevatedButton(
                        onPressed: () {
                          if (UpdateData.TelChange(
                              LoginScreen.allID, userTelController.text))
                          {
                            Fluttertoast.showToast(msg: '?????? ??????');
                          } else {
                            Fluttertoast.showToast(msg: '?????? ??????');
                          }
                        },
                        child: Text('??????'),
                      ) ,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                          child: TextFormField(
                            controller: userCompanyNameController,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                            decoration: const InputDecoration(
                              labelText: '?????????',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Container(
                      width: 100,
                      child:
                      ElevatedButton(
                        onPressed: () {
                          if (UpdateData.companyChange(
                              LoginScreen.allID, userCompanyNameController.text))
                          {
                            Fluttertoast.showToast(msg: '?????? ??????');
                          } else {
                            Fluttertoast.showToast(msg: '?????? ??????');
                          }
                        },
                        child: Text('??????'),
                      ) ,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                          child: TextFormField(
                            enabled: LoginScreen.allGrade != 'S' ,
                            controller: userCompanyNoController,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                            decoration: const InputDecoration(
                              labelText: '????????? ??????',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                    child: Container(
                      width: 100,
                      child:
                      ElevatedButton(
                        onPressed: () {
                          if(LoginScreen.allGrade != 'S') {
                            if (UpdateData.comNoChange(
                                LoginScreen.allID,
                                userCompanyNoController.text)) {
                              Fluttertoast.showToast(msg: '?????? ??????');
                            } else {
                              Fluttertoast.showToast(msg: '?????? ??????');
                            }
                          }
                          else
                          {

                          }
                        },
                        child: Text('??????'),
                      ) ,
                    ),
                  ),
                ],
              ),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                        child: TextFormField(
                          enabled: LoginScreen.allGrade == 'D',
                          controller: userCarNoController,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                          decoration: const InputDecoration(
                            labelText: '????????????',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                  child: Container(
                    width: 100,
                    child:
                    ElevatedButton(
                      onPressed: () {
                        if(LoginScreen.allGrade == 'D') {
                          if (UpdateData.carNoChange(
                              LoginScreen.allID, userCarNoController.text))
                          {
                            Timer.periodic(Duration(minutes: 3), (timer) {
                              setState(() {
                                Fluttertoast.showToast(msg: '?????? ??????');
                              });
                            });
                          } else {
                            Timer.periodic(Duration(minutes: 3), (timer) {
                              setState(() {
                                Fluttertoast.showToast(msg: '?????? ??????');
                              });
                            });
                          }
                        }
                      },
                      child: Text('??????'),
                    ) ,
                  ),
                ),
              ],
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

  Future<bool> offDialog() async {
    return await showDialog(
        context: context,
        //barrierDismissible - Dialog??? ????????? ?????? ?????? ?????? x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog ?????? ????????? ????????? ??????
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("????????????"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  " ????????? ???????????? ???????????? ???\n ???????????????.\n ???????????? ???????????????????",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("??????"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text("??????"),
                onPressed: () {
                  LoginUpdate.LoginflagChange(LoginScreen.allID, 'N');
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          );
        });
  }
}
