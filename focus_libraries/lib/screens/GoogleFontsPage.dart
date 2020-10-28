import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleFontsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("google_fonts"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => Text("LAVAZZA", style: GoogleFonts.bevan(fontSize: 50));
}
