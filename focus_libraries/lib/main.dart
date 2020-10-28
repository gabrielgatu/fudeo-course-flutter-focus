import 'package:flutter/material.dart';

import 'package:focus_libraries/screens/FlutterIconsPage.dart';
import 'package:focus_libraries/screens/GoogleFontsPage.dart';
import 'package:focus_libraries/screens/BubbleBottomBarPage.dart';
import 'package:focus_libraries/screens/AutoSizeTextPage.dart';
import 'package:focus_libraries/screens/DatePickerPage.dart';
import 'package:focus_libraries/screens/ExpandablePage.dart';
import 'package:focus_libraries/screens/ShimmerPage.dart';
import 'package:focus_libraries/screens/PullToRefreshPage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/pull-to-refresh",
      routes: {
        "/flutter-icons": (_) => FlutterIconsPage(),
        "/google-fonts": (_) => GoogleFontsPage(),
        "/bubble-bottom-bar": (_) => BubbleBottomBarPage(),
        "/autosize-text": (_) => AutoSizeTextPage(),
        "/date-picker": (_) => DatePickerPage(),
        "/expandable": (_) => ExpandablePage(),
        "/shimmer": (_) => ShimmerPage(),
        "/pull-to-refresh": (_) => PullToRefreshPage(),
      },
    );
  }
}
