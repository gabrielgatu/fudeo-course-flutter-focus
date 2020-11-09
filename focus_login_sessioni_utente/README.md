# 🕵️‍♂️ Flutter Focus

Questa è l'applicazione principale del corso "Flutter Focus", e contiene un insieme di esempi, linee guida e best-practice per lo sviluppo di applicazioni Flutter. Diciamo che può essere vista come un evoluzione dell'applicazione di fine corso di "Flutter Start".

# Obiettivi

Personalmente amo follemente i corsi online (approfondisco difficilmente concetti in informatica attraverso manuali / tutorial), ma un punto costante che ritrovo è sempre quello di trasmettere tanta teoria e poca pratica.

Con i corsi Fudeo ho cercato di evitare esattamente questo. Ed ecco perchè tutte e due i corsi cominciano sempre con un app da sviluppare. Siamo sviluppatori, vogliamo creare app belle ed accattivanti, non imparare qual'è il collegamento tra polimorfismo ed ereditarietà (che comunque non fa male sapere :p).

L'obiettivo del corso di "Flutter Focus" è quello di mettere ulteriormente in pratica i diversi concetti visti nei corsi di "Flutter Start" e "Flutter Advanced". E' pensato per tutti quei sviluppatori che hanno imparato ad apprezzare e vedere le enormi potenzialità in Flutter, ma vorrebbero vedere ancora ed approfondire come mettere in pratica i concetti. Sappiamo tutti che non basta un singolo esempio pratico di un concetto teorico per capirne bene le potenzialità e come usarlo al meglio!

Ed ecco perchè "Flutter Focus" è nato! Sinceramente lo consiglio anche ai più esperti, che (spero) potranno notare nuovi modi di fare le cose e migliorare il proprio codice.

# Organizazzione

Il codice rispecchia fedelmente la struttura descritta nella prima sezione del corso "Flutter Advanced" ed usa gli stessi pattern.

Durante le varie sezioni del corso sono andato a mettere l'attenzione su spefici sezioni dell'app (come il login, sessioni, validazione form, ecc...), qui nel codice potrete invece vedere come il tutto si incastra. Ho cercato anche di commentare le parti principali dell'app, naturalmente per qualsiasi domanda potete tranquillamente farla sullo spazio "Generale" sulla piattaforma:
- [Vai allo spazio Generale sulla piattaforma](https://edu.fudeo.it/app/space/3c2217d4-1171-4a2e-815d-6d583cf0ade8)

# Miglioramenti futuri

Naturalmente questa è un app di un corso, e come tale non sono andato ad implementare tutta l'architettura che userei per un app di 100K righe di codice, bensi sono andato ad implementare le sue fondamenta. Discorso diverso per app di medie dimensioni (sulle 20/30K righe di codice), in quel caso penso questa architettura vada benissimo cosi com'è (ovviamente adattabile al caso).

Detto questo, vorrei lasciare qui di seguito una lista delle modifiche che consiglierei di prendere in considerazione (non per ordine di importanza):

- Introdurre il pattern "Provider" tra schermate grafiche e Repository
    - Vedasi il pattern BLoC. Approfondito nell'ultima sezione del corso di "Flutter Advanced".

- Gestione errori centralizzata e log ad un server che raccolga i diversi errori in produzione.

- Introduzione di una modalità "Development", una "Testing" ed una "Production", cosichè ad esempio il Repository abbia un server diverso a seconda della modalità di esecuzione (indispendabile per non fare pasticci!).

- Utilizzo della feature "Nullable types" di Dart per aggiungere maggiore sicurezza al codice scritto.
    - https://dart.dev/null-safety