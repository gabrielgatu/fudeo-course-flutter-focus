import 'package:flutter/material.dart';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

import 'package:focus_login_sessioni_utente/util/ValidationBlock.dart';

import 'package:focus_login_sessioni_utente/main.dart';

import 'package:focus_login_sessioni_utente/components/AppFormField.dart';
import 'package:focus_login_sessioni_utente/components/AppButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(text: "gabrielgatu@icloud.com");
  final TextEditingController passwordController = TextEditingController(text: "password");

  // Variabili di stato per gestire eventuali errori di validazione del form.
  String emailError;
  String passwordError;

  // Variabile di stato per indicare se Repository.login sta caricando
  bool isLoading = false;

  void onLoginSubmitted(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Reset messaggi errore (altrimenti rimarrebbero anche se un campo fosse corretto)
    setState(() {
      emailError = null;
      passwordError = null;
    });

    // Validazione campi form
    final valid = validationBlock((when) {
      when(email.isEmpty, () => setState(() => emailError = "Campo richiesto."));
      when(email.isNotEmpty && !isValidEmail(email), () => setState(() => emailError = "Email non valida."));
      when(password.isEmpty, () => setState(() => passwordError = "Campo richiesto."));
      when(password.isNotEmpty && password.length < 6,
          () => setState(() => passwordError = "La password deve contenere almeno 6 caratteri."));
    });
    if (!valid) return;

    try {
      setState(() => isLoading = true);
      await getIt.get<Repository>().user.login(email, password);
      setState(() => isLoading = false);

      await Navigator.popAndPushNamed(context, "/home");
    } catch (error) {
      print("errore nel login: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
            child: Text("Non hai ancora un account?",
                style: TextStyle(
                  color: Colors.black54,
                )),
            onPressed: () => Navigator.pushNamed(context, "/register"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text("Ben ritornato!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),
              Text("Inserisci le tue credenziali per continuare",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                  )),
              SizedBox(height: 60),
              AppFormField(
                icon: Icons.person,
                name: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                error: emailError,
              ),
              SizedBox(height: 30),
              AppFormField(
                icon: Icons.lock,
                name: "Password",
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                error: passwordError,
              ),
              SizedBox(height: 40),
              AppButton(
                onPressed: () => onLoginSubmitted(context),
                child: isLoading
                    ? SizedBox(
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
                      )
                    : Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
