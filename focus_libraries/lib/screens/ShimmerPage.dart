import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("shimmer"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => Padding(
        padding: EdgeInsets.all(50),
        child: Shimmer.fromColors(
          baseColor: Colors.red.shade200,
          highlightColor: Colors.red.shade800,
          child: Text(
            "AWESOME!",
            style: TextStyle(fontSize: 50),
          ),
        ),
      );
}
