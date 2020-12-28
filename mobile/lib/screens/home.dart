import 'package:Irrigation/models/device.dart';
import 'package:Irrigation/screens/components/device_card.dart';
import 'package:Irrigation/models/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showInformationDialog(BuildContext context,
      DevicesManager devicesManager, Device device) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _textEditingController =
            TextEditingController(text: device.label);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actionsPadding: EdgeInsets.symmetric(horizontal: 2),
              title: Text("Relé " + device.id.toString()),
              content: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _textEditingController,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Invalid Field";
                      },
                      decoration:
                          InputDecoration(hintText: "Nome do dispositivo"),
                      autocorrect: false,
                      maxLength: 20,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Voltar'),
                  onPressed: () {
                    _formKey.currentState.reset();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      super.setState(() {
                        var novoLabel = _textEditingController.text;
                        device.label = novoLabel;
                        device.setLabel(novoLabel);
                      });

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DevicesManager>(
      builder: (_, devicesManager, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Smart Control"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Center(child: CircularProgressIndicator());
                        });
                      });
                  await devicesManager.getDevices();
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          body: Container(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 2));
                devicesManager.getDevices();
              },
              child: FutureBuilder(
                future: devicesManager.getDevices(),
                // ignore: missing_return
                builder: (context, projectSnap) {
                  switch (projectSnap.connectionState) {
                    case ConnectionState.none:

                    case ConnectionState.active:

                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.done:
                      if (projectSnap.hasError)
                        return Center(
                          child: Text("Houve algum erro"),
                        );
                      return devicesManager.devices.isNotEmpty
                          ? ListView(
                              physics: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              children: devicesManager.devices
                                  .map((e) => GestureDetector(
                                      child: DeviceCard(device: e),
                                      onTap: () => showInformationDialog(
                                          context, devicesManager, e)))
                                  .toList())
                          : Center(
                              child: Text("Nenhum dispositivo no servidor"),
                            );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
