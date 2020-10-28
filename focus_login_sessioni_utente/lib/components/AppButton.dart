import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({
    @required this.onPressed,
    @required this.child,
    this.backgroundColor = const Color(0xFF0801FC),
  });

  final Function onPressed;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      height: 60,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      textColor: Colors.white,
      child: child,
    );
  }
}
