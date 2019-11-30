package it.justmeet.justmeet.controllers;

import java.io.IOException;
import java.net.URISyntaxException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.auth.UserRecord.CreateRequest;
import com.google.gson.JsonElement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import it.justmeet.justmeet.DatabaseConfig;
import it.justmeet.justmeet.exceptions.EmailAlreadyExistsException;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.auth.LoginModel;
import it.justmeet.justmeet.models.auth.SignupModelInstitution;
import it.justmeet.justmeet.models.auth.SignupModelUser;

@RestController
public class AuthController {
    @Autowired
    UserRepository userRepo;

    @PostMapping("/login")
    public Object login(@RequestParam("email") String email, @RequestParam("password") String password)
            throws IOException, SQLException, URISyntaxException {
        Object json = fireBaseSignIn(email, password);
        // Statement st = DatabaseConfig.getConnection().createStatement();
        // ResultSet rs = st.executeQuery("SELECT * FROM users;");
        // while (rs.next()) {
        // System.out.println(rs.getString("id"));
        // System.out.println(rs.getString("email"));
        // }
        return json;
    }

    @PostMapping("/signupInstitution")
    public UserRecord signupInstitution(@RequestBody SignupModelInstitution institution)
            throws EmailAlreadyExistsException, SQLException, URISyntaxException {
        CreateRequest request = new CreateRequest().setEmail(institution.getEmail()).setEmailVerified(false)
                .setPassword(institution.getPassword()).setDisplayName(institution.getName()).setDisabled(false);

        UserRecord userRecord = null;

        try {
            userRecord = FirebaseAuth.getInstance().createUser(request);
        } catch (FirebaseAuthException e) {
            if (e.getErrorCode() == "email-already-exists") {
                throw new EmailAlreadyExistsException();
            }
        }
        Statement st = DatabaseConfig.getConnection().createStatement();
        st.executeUpdate(
                "INSERT INTO users (id,email) VALUES ('" + userRecord.getUid() + "','" + userRecord.getEmail() + "');");

        return userRecord;
    }

    @PostMapping("/signupUser")
    public UserRecord signupUser(@RequestBody SignupModelUser user)
            throws EmailAlreadyExistsException, SQLException, URISyntaxException {
        CreateRequest request = new CreateRequest().setEmail(user.getEmail()).setEmailVerified(false)
                .setPassword(user.getPassword()).setDisplayName(user.getFirstName() + " " + user.getLastName())
                .setDisabled(false);

        UserRecord userRecord = null;

        try {
            userRecord = FirebaseAuth.getInstance().createUser(request);
        } catch (FirebaseAuthException e) {
            if (e.getErrorCode() == "email-already-exists") {
                throw new EmailAlreadyExistsException();
            }
        }
        userRepo.save(new User(userRecord.getUid(), user.getFirstName(), user.getLastName(), user.getEmail(),
                user.getBirthDate()));

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