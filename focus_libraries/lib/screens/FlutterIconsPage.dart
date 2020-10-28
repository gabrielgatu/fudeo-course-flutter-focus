import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class FlutterIconsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter_icons"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => Icon(FontAwesome.stack_overflow, size: 100);
}
