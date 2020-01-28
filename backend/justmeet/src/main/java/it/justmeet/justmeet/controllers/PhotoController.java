package it.justmeet.justmeet.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuthException;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.exceptions.ForbiddenAccess;
import it.justmeet.justmeet.models.Photo;
import it.justmeet.justmeet.models.repositories.PhotoRepository;

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
	PhotoRepository photoRepo; // jpa è una libreria

	/**
	 * metodo che mi permette di eliminare una foto
	 * 
	 * @param photoId
	 * @param Authorization
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/photo/{photoId}")
	public boolean deletePhoto(@PathVariable("photoId") Long photoId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		// Cancella dal database
		Photo p = photoRepo.findById(photoId).get();
		if (!p.getUser().getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			throw new ForbiddenAccess("Stai cercando di eliminare una foto non tua");
		}
		try {
			photoRepo.delete(p);
			return true;
		} catch (Exception e) {
		}
		return false;
	}
}