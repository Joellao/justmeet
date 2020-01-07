package it.justmeet.justmeet.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuthException;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.Photo;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.PhotoRepository;
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
public class PhotoController {

	@Autowired
	UserRepository userRepo; // jpa è una libreria
	@Autowired
	EventRepository eventRepo;
	@Autowired
	PhotoRepository photoRepo; // jpa è una libreria

	/**
	 * metodo che mi permette di eliminare una foto
	 * 
	 * @param photoId
	 * @param Authorization
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/photo/{photoId}")
	public void deletePhoto(@PathVariable("photoId") Long photoId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		// Cancella dal database
		Photo p = photoRepo.findById(photoId).get();
		if (!p.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return;
		}
		photoRepo.delete(p);
	}
}