import 'package:Irrigation/device.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  const DeviceCard({Key key, this.device, this.onChange}) : super(key: key);
  final Device device;
  final Function onChange;

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool isSwitchedFT;

  @override
  void initState() {
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() {
    isSwitchedFT = widget.device.onOff;
    setState(() {});
  }
  Future<bool> saveSwitchState(bool value) async {
    return await widget.device.toggleOnOff(value);
  }

  @override
  Widget build(BuildContext context) {
    

    return Card(
      margin: EdgeInsets.all(7),
      child: Container(
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Row(
              children: [
                Icon(Icons.power),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: Text(widget.device.label),
                ),
              ],
            ),
            Switch(
              onChanged: (value){
                setState(() {
                  isSwitchedFT = value;
                  saveSwitchState(value);
                  print('Saved state is $isSwitchedFT');
                  //switch works
                });
              },
              value: isSwitchedFT,
            )
          ],
        ),
      ),
    );
  }
}
