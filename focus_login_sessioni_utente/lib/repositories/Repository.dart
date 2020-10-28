import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';

import 'package:focus_login_sessioni_utente/repositories/SessionRepository.dart';
import 'package:focus_login_sessioni_utente/repositories/UserRepository.dart';

// L'URL attuale punta ad un mini-server che ho creato ed hostato personalmente su Vercel affinche
// l'applicazioni funzioni con un server reale, e non con richieste "false" (mockup).
// Naturalmente si prega di non farlo esplodere :)
const String HOST = "https://tmpserver.vercel.app";

// Questa è una delle classi più importanti di tutta l'applicazione.
//
// In generale il Repository è la classe di riferimento per fare chiamate HTTP verso l'esterno, ed implementa
// l'omonimo "Repository" pattern.
//
// Il vantaggio dell'avere questa classe "base", attraverso cui passano tutte le richieste HTTP verso l'esterno è
// che centralizza in un singolo file tutte le configurazioni e formattazioni fatte per una chiamata prima che vada verso l'esterno.
//
// Tra queste possiamo trovare:
// - URL del server impostato dinamicamente, e modificabile in una singola riga (riga 9).
// - JWT Token impostato dinamicamente nella Header della chiamata nel caso sia presente nella sessione attiva.
// - Formattazione di tutti i vari argomenti, che siano Query o Body, cosiche come definizione di metodi personalizzati per richieste Multipart (richieste con file).
//
// In particolare, questa classe è stata concetualizzata e sviluppata da me (Gabriel Gatu) nel corso di varie applicazioni,
// non so se sia il metodo migliore ma sicuramente nel corso degli ultimi 2 anni ha dato veramente tante soddifazioni.
class Repository {
  HttpClient http;

  SessionRepository session;
  UserRepository user;

  Repository() {
    http = HttpClient(this);

    session = SessionRepository(this);
    user = UserRepository(this);
  }
}

// Questa classe rappresenta l'HTTP client ed è quello attraverso cui passano tutte le richieste.
// Il Repository istanzia ed ha un riferimento a questa classe valido per tutta la durata di esecuzione dell'app (se chiudi e riapri l'app, si ricreano sia Repository che HttpClient ovviamente).
// A sua volta, HttpClient ha un riferimento all'istanza del Repository, cosiche possa accedere alla sessione attiva, e da li recuperare il token JWT.
class HttpClient {
  final Repository repository;
  http.Client client;

  HttpClient(this.repository) {
    client = http.Client();
  }

  Map<String, String> headers() {
    if (repository.session.jwt != null)
      return {
        "Authorization": "Bearer ${repository.session.jwt}",
      };
    else
      return {};
  }

  String buildUrl(String url, Map queryParameters) {
    final params = URLQueryParams();
    queryParameters?.removeWhere((key, value) => value == null);
    queryParameters?.forEach((key, value) => params.append(key, value));

    return "$HOST/api/v2$url?${params.toString()}";
  }

  Map<String, String> encodeBody(Map<String, dynamic> body) {
    body.removeWhere((key, value) => value == null);
    return body.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<http.Response> get(url, {Map queryParameters}) => http.get(buildUrl(url, queryParameters), headers: headers());

  Future<http.Response> post(url, {Map queryParameters, Map<String, dynamic> bodyParameters}) =>
      http.post(buildUrl(url, queryParameters), headers: headers(), body: encodeBody(bodyParameters));

  Future<http.Response> postMultipart(
    url, {
    Map queryParameters,
    Map<String, dynamic> bodyParameters = const {},
    Map<String, File> fileParameters = const {},
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse(buildUrl(url, queryParameters ?? {})));

    bodyParameters.forEach((key, value) {
      request.fields[key] = value;
    });

    fileParameters.forEach((key, file) async {
      var requestFile = await http.MultipartFile.fromPath(key, file.path);
      request.files.add(requestFile);
    });

    var response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> patch(url, {Map queryParameters, Map<String, dynamic> bodyParameters}) =>
      http.patch(buildUrl(url, queryParameters), headers: headers(), body: encodeBody(bodyParameters));

  Future<http.Response> delete(url, {Map queryParameters}) =>
      http.post(buildUrl(url, queryParameters), headers: headers());
}

class RequestError implements Exception {
  final String error;
  RequestError(this.error);
}
