package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.Review;
import it.justmeet.justmeet.models.ReviewCreate;

@RestController
public class ReviewController {
    @PostMapping("/review")
    public Review addReview(@RequestBody ReviewCreate review, @RequestHeader("Authorization") String token)
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        // CHIAMATA AL DATABSE CON userId per avere l'utente
        return new Review(null, null, null, 0, null);
    }

    @GetMapping("/review/{reviewId}")
    public Review getReview(@PathVariable("reviewId") String reviewId) {
        // Select dal databse e ritorni
        return new Review(null, null, reviewId, 0, reviewId);
    }

    @PutMapping("/review/{reviewId}")
    public Review modifyReview(@PathVariable("reviewId") String reviewId, @RequestBody ReviewCreate review) {
        // Modifica al database con le nuove cose
        return new Review(null, null, reviewId, 0, reviewId);
    }

    @DeleteMapping("/review/{reviewId}")
    public void deleteReview(@PathVariable("reviewId") String reviewId) {
        // Cancella dal database
    }
}