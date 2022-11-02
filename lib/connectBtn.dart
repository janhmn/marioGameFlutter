// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ConnectButton extends StatelessWidget {
  Future<void> Function() connectDevice;

  ConnectButton({Key? key, required this.connectDevice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, 0),
        child: FloatingActionButton(
            onPressed: connect(), child: Icon(Icons.bluetooth_connected)));
  }

  connect() {
    connectDevice();
  }
}
