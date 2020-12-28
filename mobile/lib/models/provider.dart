import 'dart:convert';

import 'package:Irrigation/models/device.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DevicesManager extends ChangeNotifier {
  static const String url = 'https://irrigation-uberlandia.herokuapp.com/';

  List<Device> devices = [];

  DevicesManager() {
   
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
      
      devices = list;
      devices.sort((a, b) => a.id.compareTo(b.id));
      
    }
    
  }
  
}
