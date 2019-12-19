package it.justmeet.justmeet.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.Event;
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
