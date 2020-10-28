// Questa è una piccola ma "fighissima" funzione per validare form: molte volte capita di avere almeno 3-4 campi
// che chiediamo all'utente di compilare in un app, o per registrarsi, o per scegliere l'indirizzo di spedizione,
// o anche solo per pubblicare un post.
//
// Ecco che in questi casi dovendo validare, ad esempio, 3 campi, dobbiamo scrivere un mucchio di codice ripetitivo,
// perche se uno di questi 3 campi non è compilato correttamente, vogliamo farlo presente all'utente ed allo stesso tempo
// non procedere con la richiesta.
//
// Inoltre la cosa migliore da fare durante la validazione di un form, è far vedere immediatamente all'utente tutti i campi non corretti,
// non solo il primo (cosa che invece fanno molti).
//
// Questa funzione fa esattamente questo, permette di validare numerose condizioni, e se una di queste fallisce,
// lei continua a validare anche le altre condizioni, ma alla fine restituira "false", ovvero validazione fallita.
//
// La funzione "fn" viene utilizzata dalle schermate grafiche per poter utilizzare il setState dell'errore trovato,
// creando cosi un ottima sinergia in poche righe di codice.
bool validationBlock(Function block) {
  bool valid = true;
  final when = (bool condition, Function fn) {
    valid = valid && !condition;
    if (condition && fn != null) fn();
  };

  block(when);
  return valid;
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}
