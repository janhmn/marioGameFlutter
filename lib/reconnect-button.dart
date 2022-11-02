// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReconnectButton extends StatelessWidget {
  const ReconnectButton(
      {Key? key, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        child,
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Connect To eSense"),
        )
      ]),
    );
  }
}
