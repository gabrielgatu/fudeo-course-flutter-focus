import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AutoSizeTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("auto_size_text"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => AutoSizeText(
        'A really long String A really long String A really long String A really long String A really long String A really long String A really long String A really long String A really long String A really long String',
        style: TextStyle(fontSize: 30),
        minFontSize: 18,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      );
}
