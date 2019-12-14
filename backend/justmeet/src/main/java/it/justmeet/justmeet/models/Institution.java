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
@Table(name = "users")
@DiscriminatorValue("2")
public class Institution extends AbstractUser {

    public Institution(String uid, String name, String email) {
        super(uid, name, email);
    }

    public String getName() {
        return firstName;
    }

    public String getEmail() {
        return email;
    }

}