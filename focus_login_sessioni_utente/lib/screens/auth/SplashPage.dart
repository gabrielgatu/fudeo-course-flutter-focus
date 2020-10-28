import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

import 'package:focus_login_sessioni_utente/main.dart';

import 'package:focus_login_sessioni_utente/components/AppButton.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await getIt.get<Repository>().session.init();
      bool isUserLogged = getIt.get<Repository>().session.isUserLogged();

      if (isUserLogged)
        await Navigator.popAndPushNamed(context, "/home");
      else
        await Navigator.popAndPushNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/splash-screen-bg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Lavoriamo Insieme",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -4,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Funziona tutto meglio quando si collabora.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 40),
                AppButton(
                  onPressed: () {},
                  backgroundColor: Colors.black,
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: Colors.white,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
