import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  AppFormField({
    @required this.icon,
    @required this.name,
    @required this.controller,
    @required this.keyboardType,
    this.error,
    this.obscureText = false,
  });

  final IconData icon;
  final String name;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String error;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black26,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: Row(children: [
            Icon(icon, color: Colors.black26, size: 22),
            SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: name,
                ),
              ),
            ),
          ]),
        ),
        if (error != null)
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
