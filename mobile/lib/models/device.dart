import 'package:Irrigation/models/provider.dart';
import 'package:http/http.dart' as http;

class Device {
  String label;
  int id;
  bool onOff;

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    onOff = json['onOff'];
  }

  Future<bool> toggleOnOff(bool val) async {
    final url = DevicesManager.url;
    var response = await http.put(
      url + 'pumps/' + id.toString() + '/',
      body: {'onOff': val.toString()},
    );
    if (response.statusCode == 200) return true;
    return false;
  }

  Future<bool> setLabel(String name) async {
    final url = DevicesManager.url;
    var response = await http.put(
      url + 'pumps/' + id.toString() + '/',
      body: {'label': name},
    );
    if (response.statusCode == 200) return true;
    return false;
  }
}
