## FRONTEND

Per il Frontend è stato utilizzato il framework **Flutter** che ci permette di creare app native sia per ios che android. La scelta di Flutter è stata dettata soprattuto dal fatto che è possibile avere una codebase unica per le applicazioni Android e iOS. Inoltre Flutter mette a disposizione l'hot reload che non richiede di ricompilare il codice;

Login Screen             |  Profile Screen |          Map of Events
:-------------------------:|:-------------------------:
![](https://i.imgur.com/UnxY6vC.png) |  ![](https://i.imgur.com/uxR0rEj.png)|![](https://i.imgur.com/b8XpjiA.png)

 Il codice è stato scritto in **Dart**, un nuovo e moderno linguaggio orientato agli oggetti che definisce la maggior parte del suo sistema (gesture, animazioni, framework, widget, ecc.) e che è supportato da Flutter.

Per l&apos;autenticazione è stato usato **Firebase**, così come per l&apos;archiviazione delle foto caricate dagli utenti. La scelta di Firebase è stata dettata da vari fattori come:

1. la disponibilità di librerie client per integrare Firebase in ogni app. Android e Ios.
2. i dati immagazzinati in Firebase sono replicati e sottoposti a backup continuamente.
3. il servizio totalmente gratuito.

Per quanto riguarda la persistenza dei dati, abbiamo usato un database salvato su **heroku** che viene collegato ad un backend fatto con **Spring boot** in java, dove si gestisce la logica dell&apos;applicazione.

Heroku è un platform as a service sul cloud che supporta diversi linguaggi di programmazione.  Su heroku abbiamo creato il progetto, che tramite un deploy automatico prende il codice dalla repository di github e fa l'installazione del backend con i vari parametri di avvio.

Tramite le REST API date nel backend facciamo le chiamate dal frontend per modificare lo stato dell&apos;applicazione. 

Per il Frontend sono stati usati diversi plugin:

1. Firebaseauth per l&apos;autenticazione
2. Provider per state management
3. Dio per le chiamate rest
4. Image picker per scegliere le immagini dalla galleria
5. Permission handler per i permessi che servono all&apos;applicazione tipo geolocalizzazione e per la galleria
6. Google maps flutter per la visualizzazione della mappa
7. Photo view per l&apos;apertura delle foto
8. Geolocator per prendere le coordinate dell&apos;utente.

Per installare le dipendenze da riga di comando
```shell
flutter pub get
```

Per lanciare l&apos;app da riga di comando possiamo usare il comando
```shell
flutter run 
```

Per buildare in apk da riga di comando 
```shell
flutter build apk
```
