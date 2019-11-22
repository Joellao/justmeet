package it.justmeet.justmeet.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.models.User;

@RestController
public class UserController {
    @GetMapping("/user/{username}")
    public User get(@PathVariable("id") String name) {
        return new User(name, "ciao");
    }
}