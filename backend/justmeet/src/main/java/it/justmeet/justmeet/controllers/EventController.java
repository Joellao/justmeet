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
import it.justmeet.justmeet.models.creates.ReviewCreate;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.creates.CommentCreate;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.Photo;
import it.justmeet.justmeet.models.Review;

import org.springframework.web.bind.annotation.PutMapping;


/**
 * Responsabilità: coordina le azioni che si possono eseguire in un evento
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class EventController {
    @Autowired
    UserRepository userRepo; // jpa è una libreria
    @Autowired
    EventRepository eventRepo; // per collegare il database con il codice
    @Autowired
    CommentRepository commentRepo; //
    @Autowired
    ReviewRepository reviewRepo;

    /**
     * metodo che mi permette dic reare un nuovo evento 
     * 
     * @param event
     * @param token
     * @return l'evento creato
     * @throws FirebaseAuthException
     */
    @PostMapping("/event")
    public Event createEvent(@RequestBody EventCreate event, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        AbstractUser user = userRepo.findByUid(userId);
        // CHIAMATA AL DATABSE CON userId per avere l'utente
        Event evento = new Event(event.getName(), event.getLocation(), event.getDescription(), event.getDate(),
                event.isFree(), event.getCategory(), event.getMaxPersons());
        evento.setUser(user);
        eventRepo.save(evento);
        user.addEvent(evento);
        userRepo.save(user);

        return evento;
    }

    /**
     * metodo che grazie alla chiamata get mi permette di visualizzare l'evento
	 * in base al suo id di riconoscimento
	 * 
     * @param eventId
     * @return l'id dell'evento selezionato
     */
    @GetMapping("/event/{eventId}")
    public Event getEvent(@PathVariable("eventId") Long eventId) {
        // Chiamata al databse con eventId per avere le info dell'evento
        // return new Event(eventId, null, eventId, eventId, false, eventId, 0);
        Event event = eventRepo.findById(eventId).get();
        return event;
    }

    /**
     * metodo che mi permette di modificare un evento
     * 
     * @param eventId
     * @param event
     * @return l'evento modificato
     */
    @PutMapping(value = "/event/{eventId}")
    public Event modifyEvent(@PathVariable("eventId") Long eventId, @RequestBody EventCreate event) {
        // Chiamata al database per aggiornare l'evento con i nuovi dati
        // return new Event(eventId, null, eventId, eventId, false, eventId, 0);
        Event evento = eventRepo.findById(eventId).get();
        evento.setName(event.getName());
        evento.setDate(event.getDate());
        evento.setLocation(event.getLocation());
        evento.setFree(event.isFree());
        evento.setCategory(event.getCategory());
        evento.setMaxNumber(event.getMaxPersons());
        eventRepo.save(evento);
        return evento;
    }

    /**
     * metodo che mi permette di eliminare l'evento
     * @param eventId
     */
    @DeleteMapping("/event/{eventId}")
    public void deleteEvent(@PathVariable("eventId") Long eventId) {
        // Cancella dal databse eventId
        Event evento = eventRepo.findById(eventId).get();
        eventRepo.delete(evento);
    }

    /**
     * metodo che mi permette di annullare l'evento
     * @param eventId
     */
    @PatchMapping("/event/{eventId}")
    public void cancelEvent(@PathVariable("eventId") Long eventId) {
        // Chiamata al databse per annullare l'evento identificato da eventId
    }

    /**
     * metodo che mi permete di aggiungere un commento all'evento
     * 
     * @param comment
     * @param eventId
     * @param token
     * @return l'evento con il commento 
     * @throws FirebaseAuthException
     */
    @PostMapping("/event/{eventId}/comment")
    public Comment addComment(@RequestBody CommentCreate comment, @PathVariable("eventId") Long eventId,
        @RequestHeader("Authorization") String token) throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        AbstractUser user = userRepo.findByUid(userId);
        Event event = eventRepo.findById(eventId).get();
        Comment c = new Comment(comment.getBody(), user, event, comment.getDate(), false);
        event.addComment(c);

        eventRepo.save(event);
        commentRepo.save(c);
        // Chiamata al databse per aggiungere un commento legato a questo evento
        return c;
    }

    /**
     * metodo che mi permette selezionato l'evento, di aggiungere una recensione all'evento
     * @param review
     * @param eventId
     * @param token
     * @return l'evento con la relativa recensione
     * @throws FirebaseAuthException
     */
    @PostMapping("/event/{eventId}/review")
    public Review addReview(@RequestBody ReviewCreate review, @PathVariable("eventId") Long eventId,
            @RequestHeader("Authorization") String token) throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        User user = (User) userRepo.findByUid(userId);
        Event event = eventRepo.findById(eventId).get();
        Review r = new Review(user, event, review.getBody(), review.getStars(), review.getDate());
        event.addReview(r);

        eventRepo.save(event);
        reviewRepo.save(r);
        // Chiamata al databse per aggiungere un commento legato a questo evento
        return r;
    }

    /*
    @PostMapping("/event/{eventId}/photo")
    public Photo addPhoto(@RequestBody String url, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        // Chiamata al databse per aggiungere una foto all'evento
        return new Photo(null);
    }

    // @PostMapping("/event/{eventId}/partecipate")
    // public boolean partecipateEvent(@PathVariable("eventId") Long eventId,
    // @RequestHeader("Authorization") String token)
    // throws FirebaseAuthException {
    // FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
    // String userId = check.getUid();
    // User user = userRepo.findByUid(userId);
    // Event event = eventRepo.findById(eventId).get();
    // user.partecipateEvent(event);
    // event.addPartecipant(user);
    // eventRepo.save(event);
    // userRepo.save(user);
    // return true;
    // }*/

}