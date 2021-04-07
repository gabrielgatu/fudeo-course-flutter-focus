import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

// Questo Repository gestisce la sessione corrente dell'utente.
// Esiste una sola sessione attiva mentre l'applicazione è in esecuzione, creata al lancio dell'applicazione.
// Quando l'app viene chiusa, la sessione viene terminata.
// Quando l'app viene lanciata, la sessione viene creata e la funzione "init" viene richiamata in fase di caricamento, dalla SplashScreen (che continuerà a vedersi sino a quando "init" non sarà completata).
class SessionRepository {
  SessionRepository(this.repository);
  final Repository repository;

  // Quando l'utente è loggato, questa variabile contiene il token JWT dell'utente, altrimenti è NULL.
  String jwt;

  // Metodo richiamato dalla SplashScreen per inizializzare la sessione dell'utente.
  // Nel caso l'utente sia già loggato, avremmo la JWT salvata nella memoria del telefono (SharedPreferences).
  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.jwt = prefs.getString("TOKEN");
  }

  // setJwt va a salvare il nuovo token sia nella sessione corrente sia nella memoria del dispositivo, cosiche
  // quando l'app viene chiusa e poi riaperta, la sessione possa essere recuperata e l'utente non debba rifare il login.
  void setJwt(String jwt) async {
    this.jwt = jwt;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (jwt == null)
      prefs.remove("TOKEN");
    else
      prefs.setString("TOKEN", jwt);
  }

  void logout() {
    setJwt(null);
  }

  bool isUserLogged() {
    return jwt != null;
  }
}
