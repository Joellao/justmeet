package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.EventCreate;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.CommentCreate;
import it.justmeet.justmeet.models.Event;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
public class EventController {
    @PostMapping("/event")
    public Event createEvent(@RequestBody EventCreate event, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        // CHIAMATA AL DATABSE CON userId per avere l'utente
        User utente = new User("Pinco", "Pallino", "pinco@gmial.com", "12/12/12", null, "Life is good, go and die!");
        Event evento = new Event(event.getName(), utente, event.getLocation(), event.getDate(), event.isFree(),
                event.getCategory(), event.getMaxPersons());
        return evento;
    }

    @GetMapping("/event/{eventId}")
    public Event getEvent(@PathVariable("eventId") String eventId) {
        // Chiamata al databse con eventId per avere le info dell'evento
        return new Event(eventId, null, eventId, eventId, false, eventId, 0);
    }

    @PutMapping(value = "/event/{eventId}")
    public Event modifyEvent(@PathVariable("eventId") String eventId, @RequestBody EventCreate event) {
        // Chiamata al database per aggiornare l'evento con i nuovi dati
        return new Event(eventId, null, eventId, eventId, false, eventId, 0);
    }

    @DeleteMapping("/event/{eventId}")
    public void deleteEvent(@PathVariable("eventId") String eventId) {
        // Cancella dal databse eventId
    }

    @PatchMapping("/event/{eventId}")
    public void cancelEvent(@PathVariable("eventId") String eventId) {
        // Chiamata al databse per annullare l'evento identificato da eventId
    }

    @PostMapping("/event/comment")
    public Comment addComment(@RequestBody CommentCreate comment, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        // Chiamata al databse per aggiungere un commento legato a questo evento
        return new Comment(null, null, null, null, false);
    }

    @PostMapping("/event/photo")
    public Comment addPhoto(@RequestBody String url, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        // Chiamata al databse per aggiungere una foto all'evento
        return new Comment(null, null, null, null, false);
    }
}