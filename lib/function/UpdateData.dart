import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';

class UpdateData{
  String loginID;

  UpdateData(this.loginID);

  static passwordChange(userID, password)
  async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdatePassWord), body: {
      'userID': userID,
      'userPassword': password,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true)
      {
        result = true;
      }
      else
      {
        result = false;
      }
    }
    return result;
  }
}