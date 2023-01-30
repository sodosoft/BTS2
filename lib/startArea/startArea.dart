import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';

class StartArea{
  String startArea;

  StartArea(this.startArea);

  static SEOUL(startArea) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdatePassWord), body: {
      'startArea': startArea,
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