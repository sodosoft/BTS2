import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';

class AreaFlag{
  String areaAddress;

  AreaFlag(this.areaAddress);

  static startArea(startArea) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.StartArea), body: {
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

  static endArea(endArea) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.EndArea), body: {
      'endArea': endArea,
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
