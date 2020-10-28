import 'dart:io';
import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:focus_login_sessioni_utente/repositories/Repository.dart';

import 'package:focus_login_sessioni_utente/models/PlanType.dart';

import 'package:focus_login_sessioni_utente/util/ValidationBlock.dart';
import 'package:focus_login_sessioni_utente/util/ImageResizer.dart';

import 'package:focus_login_sessioni_utente/main.dart';

import 'package:focus_login_sessioni_utente/components/AppFormField.dart';
import 'package:focus_login_sessioni_utente/components/AppButton.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController pageController = PageController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final picker = ImagePicker();

  // Variabili di stato per gestire eventuali errori di validazione del form.
  String fullNameError;
  String emailError;
  String passwordError;
  String confirmPasswordError;

  // Traccia la pagina corrente (del PageView)
  int activePageIndex = 0;

  // Null di default. Contiene immagine scelta dall'utente per il suo avatar.
  File avatarFile;

  // Indica se l'utente ha scelto una registrazione premium. (Vorra dire che dobbiamo andare alla 2 pagina del PageView)
  bool isPremiumRegistrationActive = false;

  // Indica il piano (in caso di account premium) scelto dall'utente. Da ignorare nel caso l'utente non selezioni l'account premium.
  PlanType selectedPlan = PlanType.Base;

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      setState(() => activePageIndex = pageController.page.toInt());
    });
  }

  void onSubmit(BuildContext context) async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Reset messaggi errore (altrimenti rimarrebbero anche se un campo fosse corretto)
    setState(() {
      fullNameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    // Validazione campi form
    final valid = validationBlock((when) {
      when(fullName.isEmpty, () => setState(() => fullNameError = "Campo richiesto."));
      when(email.isEmpty, () => setState(() => emailError = "Campo richiesto."));
      when(email.isNotEmpty && !isValidEmail(email), () => setState(() => emailError = "Email non valida."));
      when(password.isEmpty, () => setState(() => passwordError = "Campo richiesto."));
      when(confirmPassword.isEmpty, () => setState(() => confirmPasswordError = "Campo richiesto."));
      when(password.isNotEmpty && password.length < 6,
          () => setState(() => passwordError = "La password deve contenere almeno 6 caratteri."));
      when(password != confirmPassword, () => setState(() => confirmPasswordError = "La password non coincide."));
    });
    if (!valid) return;

    // Continue with registration: get details for a premium account
    if (activePageIndex == 0 && isPremiumRegistrationActive) {
      pageController.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.linear);
    }
    // Registration submitted
    else {
      try {
        print("making http request to register");
        await getIt
            .get<Repository>()
            .user
            .register(fullName, email, password, avatarFile: avatarFile, planType: selectedPlan);

        await Navigator.popAndPushNamed(context, "/home");
      } catch (error) {
        print("errore nella registrazione: $error");
      }
    }
  }

  void getImage() async {
    // Lasciamo selezionare all'utente un file dalla galleria del dispositivo.
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);

    // Ora che abbiamo l'immagine che l'utente vuole usare come avatar non possiamo mandarla direttamente al server.
    // Questo perchè l'immagine potrebbe pesare anche parecchi MB e non ha assolutamente senso per un avatar: quindi dobbiamo ridimensionare l'immagine.
    //
    // Per fare questo (che è un operazione comunque intensiva, maneggiare una foto di 10MB per farla diventare una 300x300 non è mai un operazione da sottovalutare)
    // ci affidiamo al concetto di "Isolate" in dart: https://api.dart.dev/stable/2.10.2/dart-isolate/dart-isolate-library.html.
    //
    // Possiamo immaginare un Isolate come un Thread (o un Processo) separato da quello in cui gira l'App.
    // Ridimensionando l'immagine in questo processo in background avremmo il vantaggio di non bloccare il processo principale, e magari avere anche maggiore velocità di ridimensionamento (essendo che i telefoni moderni hanno diversi thread).
    //
    // Creiamo quindi questo "Isolate" (che poi in verità non è altro che una funzione che viene eseguita in background), e mandiamoli l'immagine da ridimensionare.
    // Quando la funzione avrà finito, otterremmo indietro l'immagine sotto forma di lista di byte (List<int>).
    //
    // Utilizziamo quindi il concetto di Completer (utlizzato anche in Flutter Advanced, nella sezione Google Maps) per bloccare l'esecuzione della funzione fino a quando
    // il processo non finisce.
    Completer<List<int>> completer = Completer<List<int>>();
    ReceivePort isolateToMainStream = ReceivePort();
    isolateToMainStream.listen((data) => completer.complete(data));

    await Isolate.spawn(
        imageResizerIsolate,
        ImageResizerData(
          sendPort: isolateToMainStream.sendPort,
          imageToResize: file,
          size: 300,
          quality: 70,
        ));

    // Infine, creiamo un file temporaneo con un nome univoco (ecco il motivo dell'uso del UUID) in cui salviamo fisicamente l'immagine ridimensionata ricevuta,
    // che poi useremmo per mandarla al server.
    final resizedFile = await completer.future;
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = path.join(tempDir.path, "${Uuid().v4()}.jpg");
    final fileImage = await File(tempFilePath).writeAsBytes(resizedFile);

    setState(() {
      avatarFile = fileImage;
    });
  }

  double getPriceForPlan() {
    switch (selectedPlan) {
      case PlanType.Base:
        return 9.99;
      case PlanType.Medium:
        return 19.99;
      case PlanType.Premium:
        return 49.99;
      default:
        return 0.0; // Non dovrebbe mai succedere ma viene richiesto dal compilatore.
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
            child: Text("Hai già un account?",
                style: TextStyle(
                  color: Colors.black54,
                )),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          buildGeneralPage(),
          buildPremiumPage(),
        ],
      ),
    );
  }

  Widget buildGeneralPage() => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text("Crea il tuo account!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),
              Text("Inserisci i dati richiesti per creare il tuo account",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                  )),
              SizedBox(height: 60),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: avatarFile != null ? AssetImage(avatarFile.path) : null,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Carica immagine",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              SizedBox(height: 50),
              AppFormField(
                icon: Icons.person,
                name: "Nome e cognome",
                controller: fullNameController,
                keyboardType: TextInputType.text,
                error: fullNameError,
              ),
              SizedBox(height: 30),
              AppFormField(
                icon: Icons.email,
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
              SizedBox(height: 30),
              AppFormField(
                icon: Icons.lock,
                name: "Conferma password",
                controller: confirmPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                error: confirmPasswordError,
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text("Registra un account premium"),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                value: isPremiumRegistrationActive,
                onChanged: (value) => setState(() => isPremiumRegistrationActive = value),
              ),
              SizedBox(height: 40),
              AppButton(
                onPressed: () => onSubmit(context),
                child: Text(isPremiumRegistrationActive ? "Personalizza il tuo account" : "Crea il tuo account"),
              ),
            ],
          ),
        ),
      );

  Widget buildPremiumPage() => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text("Personalizza il tuo piano",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),
              Text("A seconda del piano scelto avrai diversi vantaggi",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                  )),
              SizedBox(height: 60),
              buildPlan(
                name: "Piano Base",
                description:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis erat. Curabitur egestas urna magna, eu tristique orci accumsan.",
                value: PlanType.Base,
              ),
              SizedBox(height: 40),
              buildPlan(
                name: "Piano Avanzato",
                description:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis erat. Curabitur egestas urna magna, eu tristique orci accumsan.",
                value: PlanType.Medium,
              ),
              SizedBox(height: 40),
              buildPlan(
                name: "Piano Premium",
                description:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis erat. Curabitur egestas urna magna, eu tristique orci accumsan.",
                value: PlanType.Premium,
              ),
              SizedBox(height: 40),
              AppButton(
                onPressed: () => onSubmit(context),
                child: Text("Attiva piano | ${getPriceForPlan()} €"),
              ),
            ],
          ),
        ),
      );

  Widget buildPlan({
    @required String name,
    @required String description,
    @required PlanType value,
  }) =>
      RadioListTile<PlanType>(
        title: Text(name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(description,
            style: TextStyle(
              color: Colors.black54,
            )),
        value: value,
        groupValue: selectedPlan,
        onChanged: (value) => setState(() => selectedPlan = value),
      );
}
