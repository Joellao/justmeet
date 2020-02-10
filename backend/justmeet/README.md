## BACKEND

Il backend è stato scritto in java e per runnare il progetto abbiamo usato **Spring boot.**

Il progetto è basato su un architettura** MVC**, dove tutta la parte di View viene implementata nel frontend con Flutter.

Per l&apos;autenticazione è stato usato **Firebase**, così come per l&apos;archiviazione delle foto caricate dagli utenti. La scelta di Firebase è stata dettata da vari fattori come:

1. la disponibilità di librerie client per integrare Firebase in ogni app. Android e Ios.
2. i dati immagazzinati in Firebase sono replicati e sottoposti a backup continuamente.
3. il servizio totalmente gratuito.

Per quanto riguarda la persistenza dei dati, abbiamo usato un database salvato su **heroku** che viene collegato ad un backend fatto con **Spring boot** in java, dove si gestisce la logica dell&apos;applicazione. 

Heroku è un platform as a service sul cloud che supporta diversi linguaggi di programmazione.  Su heroku abbiamo creato il progetto, che tramite un deploy automatico prende il codice dalla repository di github e fa l&apos;installazione del backend con i vari parametri di avvio.

Abbiamo usato **JPA** per delegare l&apos;interazione con il database, evitando così di scrivere le query nel codice e fornendo la possibilità di generare le tabelle a runtime, minimizzando il lavoro richiesto per sviluppare rapidamente applicazioni persistenti. 
In particolare abbiamo utilizzato Hibernate, un&apos;implementazione di JPA e uno dei più importanti framework ORM (Object Relation Mapping).

Per eseguire i test da riga di comando 
```shell
./mvnw test
```