package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuthException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.ReportProblem;
import it.justmeet.justmeet.models.repositories.AbstractUserRepository;
import it.justmeet.justmeet.models.repositories.ReportProblemRepository;

/**
 * Responsabilità: coordina le azioni che può eseguire un utente qualsiasi
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class ReportProblemController {
    @Autowired
    ReportProblemRepository rpRepo;
    @Autowired
    AbstractUserRepository abstractRepo;

    /**
     * metodo che mi permette di visualizzare il profilo dell'utente in base al suo
     * id
     * 
     * @param name
     * @param token
     * @return l'utente selezionato in base all'username
     * @throws FirebaseAuthException
     */
    @PostMapping("/report")
    public ReportProblem reportProblem(@RequestHeader("Authorization") String token, @RequestParam("body") String body)
            throws FirebaseAuthException {
        String userId = WoWoUtility.getInstance().getUid(token);
        AbstractUser user = abstractRepo.findByUid(userId);
        ReportProblem problem = new ReportProblem(user, body);
        try {
            return rpRepo.save(problem);
        } catch (Exception e) {
        }
        return null;
    }

}