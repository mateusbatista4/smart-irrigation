import 'dart:convert';

import 'package:Irrigation/device.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DevicesManager extends ChangeNotifier {
  static const String url = 'http://192.168.100.34:8000/';

  List<Device> devices = [];

  DevicesManager() {
    getDevices();
  }

  Future<void> getDevices() async {
    var response = await http.get(
      url + 'pumps/',
    );
    if (response.statusCode == 200) {
      var jsonBody = json.decode(utf8.decode(response.bodyBytes));
      List<Device> list = [];
      for (var item in jsonBody) {
        list.add(Device.fromJson(item));
      }
      print(list);
      devices = list;
      notifyListeners();
    }
    
  }
  
}
