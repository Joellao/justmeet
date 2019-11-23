package it.justmeet.justmeet.controllers;

import java.io.IOException;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.auth.UserRecord.CreateRequest;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import it.justmeet.justmeet.exceptions.EmailAlreadyExistsException;
import it.justmeet.justmeet.models.auth.LoginModel;

@RestController
public class AuthController {
    @PostMapping("/login")
    public Object login(@RequestParam("email") String email, @RequestParam("password") String password)
            throws IOException {
        Object json = fireBaseSignIn(email, password);
        System.out.println(json);
        return json;
    }

    @PostMapping("/signup")
    public UserRecord signup(@RequestParam("email") String email, @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName, @RequestParam("password") String password,
            @RequestParam("birthDate") String birthDate) throws EmailAlreadyExistsException {
        CreateRequest request = new CreateRequest().setEmail(email).setEmailVerified(false).setPassword(password)
                .setDisplayName(firstName + " " + lastName).setDisabled(false);

        UserRecord userRecord = null;

        try {
            userRecord = FirebaseAuth.getInstance().createUser(request);
        } catch (FirebaseAuthException e) {
            if (e.getErrorCode() == "email-already-exists") {
                throw new EmailAlreadyExistsException();
            }
        }
        return userRecord;
    }

    @ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Email already exists")
    @ExceptionHandler(EmailAlreadyExistsException.class)
    public void handle() {
    }

    public Object fireBaseSignIn(String email, String password) {
        LoginModel login = new LoginModel(email, password);
        RestTemplate t = new RestTemplate();
        Object result = t.postForObject(
                "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDF0V8-WK52yY_HKsoar4D0NBkY2zvn-pQ",
                login, Object.class);
        return result;
    }
}