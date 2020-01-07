package it.justmeet.justmeet.models.creates;

import java.util.Date;

/**
 * Responsabilità: si occupa della creazione di una recensione
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

public class ReviewCreate {
    public String body;
    public int stars;

    public ReviewCreate(String body, int stars) {
        this.body = body;
        this.stars = stars;
    }

    public String getBody() {
        return body;
    }

    public int getStars() {
        return stars;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public void setStars(int stars) {
        this.stars = stars;
    }

}
