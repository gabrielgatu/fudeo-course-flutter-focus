import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as datePicker;

class DatePickerPage extends StatelessWidget {
  final styles = datePicker.DatePickerRangeStyles(
    selectedPeriodLastDecoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(topRight: Radius.circular(100.0), bottomRight: Radius.circular(10.0))),
    selectedPeriodStartDecoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(100.0), bottomLeft: Radius.circular(10.0)),
    ),
    selectedPeriodMiddleDecoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter_date_picker"),
        centerTitle: true,
      ),
      body: Center(child: body()),
    );
  }

  Widget body() => datePicker.WeekPicker(
        selectedDate: DateTime.now(),
        onChanged: (_) {},
        firstDate: DateTime.now().subtract(Duration(days: 100)),
        lastDate: DateTime.now().add(Duration(days: 10)),
        datePickerStyles: styles,
      );
}
