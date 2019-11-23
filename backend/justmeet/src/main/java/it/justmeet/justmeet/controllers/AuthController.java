package it.justmeet.justmeet.controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.auth.UserRecord.CreateRequest;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import it.justmeet.justmeet.exceptions.EmailAlreadyExistsException;

@RestController
public class AuthController {
    @PostMapping("/login")
    public String login(@RequestParam("email") String email, @RequestParam("password") String password)
            throws IOException {
        JSONObject json = fireBaseSignIn(email, password);
        System.out.println(json);
        return json.toString();
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

    private static JSONObject fireBaseSignIn(String email, String password) throws IOException {
        JSONObject json = null;
        try {

            URL url = new URL(
                    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDF0V8-WK52yY_HKsoar4D0NBkY2zvn-pQ");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");

            String input = "{\"email\":\"" + email + "\",\"password\":\"" + password + "\",\"returnSecureToken\":true}";

            OutputStream os = conn.getOutputStream();
            os.write(input.getBytes());
            os.flush();

            if (conn.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
            }

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            StringBuilder sb = new StringBuilder();

            String line;

            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            json = new JSONObject(sb.toString());
            conn.disconnect();

        } catch (MalformedURLException e) {

            e.printStackTrace();

        } catch (IOException e) {

            e.printStackTrace();

        }
        return json;
    }
}