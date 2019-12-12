package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.Review;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.UserInterface;
import it.justmeet.justmeet.models.creates.ReviewCreate;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

@RestController
public class ReviewController {

	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	EventRepository eventRepo;
	@Autowired
	ReviewRepository reviewRepo; // jpa è una libreria

	@PostMapping("/review/{eventId}")
	public Review addReview(@RequestBody ReviewCreate review, @RequestHeader("Authorization") String token,
			@PathVariable("eventId") Long eventId) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
<<<<<<< HEAD
		User user = (User) userRepo.findByUid(userId);
=======
		UserInterface user = userRepo.findByUid(userId);
>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
		Event event = eventRepo.findById(eventId).get();
		// CHIAMATA AL DATABSE CON userId per avere la recensione
		Review r = new Review(user, event, review.getBody(), review.getStars(), review.getDate());
		reviewRepo.save(r);
		return r;
	}

	@GetMapping("/review/{reviewId}")
	public Review getReview(@PathVariable("reviewId") Long reviewId) {
		// Select dal databse e ritorni
		return reviewRepo.findById(reviewId).get();
	}

	@PutMapping("/review/{reviewId}")
	public Review modifyReview(@PathVariable("reviewId") Long reviewId, @RequestBody ReviewCreate review) {
		// Modifica al database con le nuove cose
		Review r = reviewRepo.findById(reviewId).get();
		r.setBody(review.getBody());
		r.setDate(review.getDate());
		r.setStars(review.getStars());
		reviewRepo.save(r);
		return r;
	}

	@DeleteMapping("/review/{reviewId}")
	public void deleteReview(@PathVariable("reviewId") Long reviewId) {
		// Cancella dal database
		Review r = reviewRepo.findById(reviewId).get();
		reviewRepo.delete(r);
	}
}