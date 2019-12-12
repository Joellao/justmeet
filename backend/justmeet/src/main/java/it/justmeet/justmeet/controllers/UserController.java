package it.justmeet.justmeet.controllers;

import java.util.List;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.UserInterface;
import it.justmeet.justmeet.models.repositories.UserRepository;

@RestController
public class UserController {
    @Autowired
    UserRepository repo1;
    @Autowired
    EventRepository repo2;

    @GetMapping("/user/{username}")
<<<<<<< HEAD
    public AbstractUser get(@PathVariable("username") String name, @RequestHeader("Authorization") String token)
=======
    public UserInterface get(@PathVariable("username") String name, @RequestHeader("Authorization") String token)
>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
            throws FirebaseAuthException {
        FirebaseToken check = FirebaseAuth.getInstance().verifyIdToken(token);
        String userId = check.getUid();
        System.out.println(userId);
<<<<<<< HEAD
        AbstractUser user = repo1.findByUid(userId);
=======
        UserInterface user = repo1.findByUid(userId);
>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
        return user;
    }
}