import 'package:flutter/material.dart';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

import 'package:focus_login_sessioni_utente/models/UserModel.dart';

import 'package:focus_login_sessioni_utente/main.dart';

class HomePage extends StatelessWidget {
  void logout(BuildContext context) async {
    getIt.get<Repository>().session.logout();
    await Navigator.popAndPushNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: getIt.get<Repository>().user.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
            else {
              final user = snapshot.data as UserModel;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.fullName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(user.email, style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              );
            }
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(child: Text("Body :)")),
    );
  }
}
