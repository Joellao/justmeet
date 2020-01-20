package it.justmeet.justmeet.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

import com.google.firebase.auth.FirebaseAuthException;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.SegnalazioneCommento;
import it.justmeet.justmeet.models.creates.CommentCreate;
import it.justmeet.justmeet.models.repositories.AbstractUserRepository;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.repositories.SegnalazioneCommentoRepository;

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
	AbstractUserRepository absRepo; // jpa è una libreria
	@Autowired
	CommentRepository commentRepo; // jpa è una libreria
	@Autowired
	SegnalazioneCommentoRepository scRepo; // jpa è una libreria

	/**
	 * metodo che mi permette di modificare un commento
	 * 
	 * @param commentId
	 * @param comment
	 * @return commento modificato
	 * @throws FirebaseAuthException
	 */
	@PutMapping("/comment/{commentId}")
	public Comment modifyComment(@PathVariable("commentId") Long commentId, @RequestBody CommentCreate comment,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {

		Comment c = commentRepo.findById(commentId).get();
		if (!c.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return null;
		}
		c.setBody(comment.getBody());
		c.setDate(new Date());
		commentRepo.save(c);
		return c;
	}

	/**
	 * metodo che mi permette di eliminare un commento
	 * 
	 * @param commentId
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/comment/{commentId}")
	public void deleteComment(@PathVariable("commentId") Long commentId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		Comment c = commentRepo.findById(commentId).get();
		if (!c.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return;
		}
		commentRepo.delete(c);
	}

	@PostMapping("/comment/{commentId}")
	public void segnala(@PathVariable("commentId") Long commentId, @RequestHeader("Authorization") String token,
			@RequestParam("body") String body) throws FirebaseAuthException {
		String uid = WoWoUtility.getInstance().getUid(token);
		SegnalazioneCommento sc = new SegnalazioneCommento(absRepo.findByUid(uid),
				commentRepo.findById(commentId).get(), body);
		scRepo.save(sc);
	}

}
