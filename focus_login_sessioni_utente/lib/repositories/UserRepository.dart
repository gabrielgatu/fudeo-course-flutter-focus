import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

import 'package:focus_login_sessioni_utente/models/PlanType.dart';
import 'package:focus_login_sessioni_utente/models/UserModel.dart';

class UserRepository {
  UserRepository(this.repository);
  final Repository repository;

  // La funziona login prende una email e password, e procede facendo una richiesta
  // POST al server con i dati.
  //
  // Il server, nel caso le credenziali siano corrette, ritornerà una Stringa,
  // che corrispondera al token JWT da utilizzare nello Header delle richieste successive
  // affinchè il server possa sapere chi sta facendo la richiesta e possa autentificare l'utente.
  // In caso di credenziali errate, il server ritornerà un oggetto {"error": "...."},
  // che indicherà di preciso qual'è l'errore di autenticazione (utente non esistente, password errata, ...).
  //
  // Inoltre, in caso di successo, questo metodo oltre che completare correttamente la Future con la JWT,
  // procede anche nell'immagazinarla nella corrente sessione attiva (esiste 1 sola sessione attiva durante tutto l'arco dell'applicazione),
  // cosiche la classe Repository, dentro di se, possa usare questo JWT per fare le prossime chiamate.
  Future<String> login(String email, String password) async {
    final response = await repository.http.post("/login", bodyParameters: {
      "email": email,
      "password": password,
    });
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final jwt = data["token"];

      repository.session.setJwt(jwt);

      return jwt;
    }

    throw RequestError(data["error"]);
  }

  // La funzione register prende il nome completo dell'utente, email e password obbligatoriamente,
  // nel caso l'utente selezioni un immagine di profilo ed la creazione di un account premium, anche questi campi non saranno nulli (altrimenti si).
  //
  // Qui subentra una cosa particolare che prima non avevamo: dobbiamo mandare al server una richiesta POST
  // con sia dei valori "primitivi", come stringhe/interi/booleani, ma anche con file (nel nostro caso un'immagine).
  //
  // Per gestire questi casi, abbiamo bisogno di impostare come "tipologia del contenuto della richiesta", o detta in inglese
  // un Content-Type, il "multipart".
  //
  // Questo tipologie di richieste è un po' particolare, ed ecco perchè andiamo ad utilizzare non più la "Repository.post" come prima,
  // ma la "Repository.postMultipart".
  //
  // Anche qui, nel caso di registrazione corretta, il server ritorna un token JWT da utilizzarsi per le prossime chiamate,
  // che viene memorizzato nella sessione corrente dell'utente.
  Future<String> register(
    String fullName,
    String email,
    String password, {
    File avatarFile,
    PlanType planType,
  }) async {
    final response = await repository.http.postMultipart("/register", bodyParameters: {
      "fullName": fullName,
      "email": email,
      "password": password,
      "planType": planType.toString(),
    }, fileParameters: {
      'avatar': avatarFile,
    });
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final jwt = data["token"];

      repository.session.setJwt(jwt);

      return jwt;
    }

    throw RequestError(data["error"]);
  }

  // La funziona getProfile ritorna il profilo dell'utente della sessione corrente.
  // Non prende nessun parametro perchè riesce ad identificare l'utente dal token JWT salvato nel SessionRepository.
  // Naturalmente se questo metoodo venisse richiamato prima del login/registrazione, ritornerebbe un errore.
  Future<UserModel> getProfile() async {
    final response = await repository.http.get("/profile");
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromData(data);
    }

    throw RequestError(data["error"]);
  }
}
