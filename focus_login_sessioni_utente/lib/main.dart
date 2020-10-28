import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

import 'package:focus_login_sessioni_utente/screens/auth/SplashPage.dart';
import 'package:focus_login_sessioni_utente/screens/auth/LoginPage.dart';
import 'package:focus_login_sessioni_utente/screens/auth/RegisterPage.dart';
import 'package:focus_login_sessioni_utente/screens/home/HomePage.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<Repository>(Repository());

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/splash': (_) => SplashPage(),
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/home': (_) => HomePage(),
      },
    );
  }
}
