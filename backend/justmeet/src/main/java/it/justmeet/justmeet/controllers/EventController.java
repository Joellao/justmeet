package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.creates.EventCreate;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.creates.CommentCreate;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.Event;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
public class EventController {
    @Autowired
    UserRepository userRepo; //jpa è una libreria
    @Autowired
    EventRepository eventRepo; //per collegare il database con il codice
    @Autowired
    CommentRepository commentRepo; //

    @PostMapping("/event")
    public Event createEvent(@RequestBody EventCreate event, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        User user = userRepo.findByUid(userId);
        // CHIAMATA AL DATABSE CON userId per avere l'utente
        Event evento = new Event(event.getName(), event.getLocation(), event.getDate(), event.isFree(),
                event.getCategory(), event.getMaxPersons());
        evento.setUser(user);
        eventRepo.save(evento);
        user.addEvent(evento);
        userRepo.save(user);
        
        return evento;
    }

    @GetMapping("/event/{eventId}")
    public Event getEvent(@PathVariable("eventId") Long eventId) {
        // Chiamata al databse con eventId per avere le info dell'evento
        // return new Event(eventId, null, eventId, eventId, false, eventId, 0);
        return eventRepo.findById(eventId).get();
    }

    @PutMapping(value = "/event/{eventId}")
    public Event modifyEvent(@PathVariable("eventId") Long eventId, @RequestBody EventCreate event) {
        // Chiamata al database per aggiornare l'evento con i nuovi dati
        // return new Event(eventId, null, eventId, eventId, false, eventId, 0);
        return null;

    }

    @DeleteMapping("/event/{eventId}")
    public void deleteEvent(@PathVariable("eventId") Long eventId) {
        // Cancella dal databse eventId
    }

    @PatchMapping("/event/{eventId}")
    public void cancelEvent(@PathVariable("eventId") Long eventId) {
        // Chiamata al databse per annullare l'evento identificato da eventId
    }

    @PostMapping("/event/{eventId}/comment")
    public Comment addComment(@RequestBody CommentCreate comment, @PathVariable("eventId") Long eventId,
            @RequestHeader("Authorization") String token) throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        User user = userRepo.findByUid(userId);
        Event event = eventRepo.findById(eventId).get();
        Comment c = new Comment(comment.getBody(), user, event, comment.getDate(), false);
        event.addComment(c);

        eventRepo.save(event);
        commentRepo.save(c);
        // Chiamata al databse per aggiungere un commento legato a questo evento
        return c;
    }

    @PostMapping("/event/photo")
    public Comment addPhoto(@RequestBody String url, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        // Chiamata al databse per aggiungere una foto all'evento
        return new Comment(null, null, null, null, false);
    }
}