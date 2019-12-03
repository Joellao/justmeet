package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.creates.EventCreate;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.Announcement;
import it.justmeet.justmeet.models.creates.AnnouncementCreate;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.creates.CommentCreate;

import org.springframework.web.bind.annotation.PutMapping;

@RestController
public class AnnouncementController {
    @PostMapping("/announcement")
    public Announcement createAnnouncement(@RequestBody AnnouncementCreate annuncio,
            @RequestHeader("Authorization") String token) throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        // CHIAMATA AL DATABSE CON userId per avere l'utente
        User utente = new User(userId, "Pinco", "Pallino", "pinco@gmial.com", "12/12/12");
        Announcement announce = new Announcement(annuncio.getName(), utente, annuncio.getCategory());
        return announce;
    }

    @GetMapping("/announcement/{announcementId}")
    public Announcement getAnnouncement(@PathVariable("announcementId") String eventId) {
        // Chiamata al databse con eventId per avere le info dell'evento
        return new Announcement(null, null, null);
    }

    @PutMapping(value = "/announcement/{announcementId}")
    public Announcement modifyAnnouncement(@PathVariable("announcementId") String announcementId,
            @RequestBody EventCreate event) {
        // Chiamata al database per aggiornare l'evento con i nuovi dati
        return new Announcement(null, null, null);
    }

    @DeleteMapping("/announcement/{announcementId}")
    public void deleteEvent(@PathVariable("announcementId") String announcementId) {
        // Cancella dal databse eventId
    }

    @PostMapping("/announcement/{announcementId}/comment")
    public Comment addComment(@RequestBody CommentCreate comment, @RequestHeader("Authorization") String token, @PathVariable("announcementId") String announcementId)
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        // Chiamata al databse per aggiungere un commento legato a questo annuncio
        return new Comment(null, null, null, null, false);
    }
}