package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.repositories.AnnouncementRepository;
import it.justmeet.justmeet.models.repositories.CommentRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.Announcement;
import it.justmeet.justmeet.models.creates.AnnouncementCreate;
import it.justmeet.justmeet.models.Comment;
import it.justmeet.justmeet.models.creates.CommentCreate;

import org.springframework.web.bind.annotation.PutMapping;

/**
 * Responsabilità: coordina le azioni che si possono eseguire sull'annuncio
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@RestController
public class AnnouncementController {
	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	AnnouncementRepository announcementRepo; // per collegare il database con il codice
	@Autowired
	CommentRepository commentRepo;

	/**
	 * chiamata post che mi permette di creare l'annuncio
	 * 
	 * @param annuncio
	 * @param token
	 * @return l'annuncio creato
	 * @throws FirebaseAuthException
	 */
	@PostMapping("/announcement")
	public Announcement createAnnouncement(@RequestBody AnnouncementCreate annuncio,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		// CHIAMATA AL DATABSE CON userId per avere l'utente
		User user = (User) userRepo.findByUid(userId);
		Announcement announce = new Announcement(annuncio.getName(), user, annuncio.getCategory());
		announcementRepo.save(announce);
		return announce;
	}

	/**
	 * metodo che grazie alla chiamata get mi permette di visualizzare l'annuncio in
	 * base al suo id di riconoscimento
	 * 
	 * @param announceId
	 * @return l'id dell'annuncio selezionato
	 */
	@GetMapping("/announcement/{announcementId}")
	public Announcement getAnnouncement(@PathVariable("announcementId") Long announceId) {
		// Chiamata al databse con eventId per avere le info dell'annuncio
		return announcementRepo.findById(announceId).get();
	}

	/**
	 * metodo che mi permette la modifica delle informazioni relative all'annuncio
	 * quali nome e categoria
	 *
	 * @param announcementId
	 * @param announce
	 * @return l'annuncio modificato
	 * @throws FirebaseAuthException
	 */
	@PutMapping(value = "/announcement/{announcementId}")
	public Announcement modifyAnnouncement(@PathVariable("announcementId") Long announcementId,
			@RequestBody AnnouncementCreate announce, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		// Chiamata al database per aggiornare l'evento con i nuovi dati
		Announcement announcement = announcementRepo.findById(announcementId).get();
		if (!announcement.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return null;
		}
		announcement.setName(announce.getName());
		announcement.setCategory(announce.getCategory());
		announcementRepo.save(announcement);
		return announcement;
	}

	/**
	 * metodo che mi permette di cancellare l'annuncio selezionato
	 * 
	 * @param announcementId
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/announcement/{announcementId}")
	public void deleteAnnouncement(@PathVariable("announcementId") Long announcementId,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		// Cancella dal databse eventId
		Announcement announce = announcementRepo.findById(announcementId).get();
		if (!announce.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return;
		}
		announcementRepo.delete(announce);
	}

	/**
	 * questo metodo mi permette di aggiungere un commneto sotto l'annuncio
	 * selezionato
	 * 
	 * @param comment
	 * @param token
	 * @param announcementId
	 * @return annuncio con il commento inserito
	 * @throws FirebaseAuthException
	 */
	@PostMapping("/announcement/{announcementId}/comment")
	public Comment addComment(@RequestBody CommentCreate comment, @RequestHeader("Authorization") String token,
			@PathVariable("announcementId") Long announcementId) throws FirebaseAuthException {
		FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
		String userId = check.getUid();
		User user = (User) userRepo.findByUid(userId);
		Announcement announcement = announcementRepo.findById(announcementId).get();
		Comment c = new Comment(comment.getBody(), user, comment.getDate(), false);
		announcement.addComment(c);
		announcementRepo.save(announcement);
		return c;
	}
}