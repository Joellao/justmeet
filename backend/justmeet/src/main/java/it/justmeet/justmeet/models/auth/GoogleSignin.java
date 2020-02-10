package it.justmeet.justmeet.models.auth;

import java.util.Date;

/**
 * Responsabilità: definisce il modello per il login dell'utente
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
public class GoogleSignin {

    private final String email;
    private final String uid;
    private final String firstName;
    private final String userName;
    private final String lastName;
    private final String date;

    public GoogleSignin(String email, String password, String uid, String firstName, String userName, String lastName,
            String date) {
        this.email = email;
        this.uid = uid;
        this.firstName = firstName;
        this.userName = userName;
        this.lastName = lastName;
        this.date = date;
    }

    public String getEmail() {
        return email;
    }

    public String getUid() {
        return uid;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getUserName() {
        return userName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getDate() {
        return date;
    }

}