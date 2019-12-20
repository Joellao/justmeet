package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.repositories.UserRepository;

/**
 * Responsabilità: coordina le azioni che può eseguire un utente qualsiasi
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class UserController {
    @Autowired
    UserRepository userRepo;

    /**
     * metodo che mi permette di visualizzare il profilo dell'utent ein base al suo
     * username
     * 
     * @param name
     * @param token
     * @return l'utente selezionato in base all'username
     * @throws FirebaseAuthException
     */
    @GetMapping("/user")
    public AbstractUser getProfile(@RequestHeader("Authorization") String token) throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        AbstractUser user = userRepo.findByUid(userId);
        return user;
    }

    /**
     * metodo che mi permette di visualizzare il profilo dell'utent ein base al suo
     * username
     * 
     * @param name
     * @param token
     * @return l'utente selezionato in base all'username
     * @throws FirebaseAuthException
     */
    @GetMapping("/user/{userId}")
    public AbstractUser getOtherProfile(@PathVariable("userId") String otherId,
            @RequestHeader("Authorization") String token) throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        AbstractUser me = userRepo.findByUid(userId);
        if (me.isCanSeeOthersProfile()) {
            AbstractUser other = userRepo.findByUid(otherId);
            return other;
        }
        return null;
    }
}