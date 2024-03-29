package it.justmeet.justmeet.models;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Responsabilità: definisce un utente autenticato istituzionale
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity(name = "Institution")
@Table(name = "institution")
@DiscriminatorValue("2")
public class Institution extends AbstractUser {

    public Institution() {
    }

    public Institution(String uid, String username, String name, String email, int type) {
        super(uid, username, name, email, type);
    }

    public String getUsername() {
        return userName;
    }

    public String getName() {
        return firstName;
    }

    public String getEmail() {
        return email;
    }
    

}