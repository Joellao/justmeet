package it.justmeet.justmeet.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuthException;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.Review;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.ReviewRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

/**
 * Responsabilità: coordina le azioni che si possono eseguire sulle recensioni
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class ReviewController {

	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	EventRepository eventRepo;
	@Autowired
	ReviewRepository reviewRepo; // jpa è una libreria
	
	/**
	 * metodo che mi permette di eliminare una recensione
	 * 
	 * @param reviewId
	 * @param Authorization
	 * @throws FirebaseAuthException 
	 */
	@DeleteMapping("/review/{reviewId}")
	public void deleteReview(@PathVariable("reviewId") Long reviewId, @RequestHeader("Authorization") String token) throws FirebaseAuthException {
		// Cancella dal database
		Review r = reviewRepo.findById(reviewId).get();
		if (!r.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return;
		}
		reviewRepo.delete(r);
	}
}