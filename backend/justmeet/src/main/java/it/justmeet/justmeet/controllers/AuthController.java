package it.justmeet.justmeet.controllers;

import java.net.URISyntaxException;
import java.sql.SQLException;
import java.sql.Statement;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.DatabaseConfig;
import it.justmeet.justmeet.models.User;

@RestController
public class AuthController {
    @PostMapping("/login")
    public User login(@RequestBody User user) throws URISyntaxException, SQLException {
        Statement st = DatabaseConfig.getConnection().createStatement();
        st.executeQuery("\\l");
        return user;
    }

    @PostMapping("/signup")
    public User signup(@RequestBody User user) {
        return user;
    }
}