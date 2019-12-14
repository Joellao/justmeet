package it.justmeet.justmeet.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.creates.CommentCreate;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

/**
 * Responsabilità: coordina le azioni che si possono eseguire sui commenti
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class CommentController {

	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	EventRepository eventRepo;
	@Autowired
	CommentRepository commentRepo; // jpa è una libreria


	/**
	 * metodo che mi permette di creare un commento
	 * 
	 * @param comment
	 * @param token
	 * @param eventId
	 * @return commento creato
	 * @throws FirebaseAuthException
	 */
	@PostMapping("/comment/{eventId}")
	public Comment addComment(@RequestBody CommentCreate comment, @RequestHeader("Authorization") String token,
			@PathVariable("eventId") Long eventId) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		AbstractUser user = userRepo.findByUid(userId);
	    Event event = eventRepo.findById(eventId).get();
	    Comment c = new Comment(comment.getBody(), user, event, comment.getDate(), false);
		commentRepo.save(c);
		return c;
	}

	/**
	 * metodo che mi permette di visualizzare il commento in base al suo id 
	 * di riconoscimento
	 * 
	 * @param commentId
	 * @return l'id del commento
	 */
	@GetMapping("/comment/{commentId}")
	public Comment getComment(@PathVariable("commentId") Long commentId) {
		// Select dal databse e ritorni
		return commentRepo.findById(commentId).get();
	}

	
	/**
	 * metodo che mi permette di modificare un commento
	 * 
	 * @param commentId
	 * @param comment
	 * @return commento modificato
	 */
	@PutMapping("/comment/{commentId}")
	public Comment modifyComment(@PathVariable("commentId") Long commentId, @RequestBody CommentCreate comment) {
		// Modifica al database con le nuove cose
		Comment c = commentRepo.findById(commentId).get();
		c.setBody(comment.getBody());
		c.setDate(comment.getDate());
		commentRepo.save(c);
		return c;
	}

	/**
	 * metodo che mi permette di eliminare un commento
	 * 
	 * @param commentId
	 */
	@DeleteMapping("/comment/{commentId}")
	public void deleteComment(@PathVariable("commentId") Long commentId) {
		// Cancella dal database
		Comment c = commentRepo.findById(commentId).get();
		commentRepo.delete(c);
	}
}
