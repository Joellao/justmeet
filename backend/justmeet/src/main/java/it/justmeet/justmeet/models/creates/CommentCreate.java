package it.justmeet.justmeet.models.creates;

import java.util.Date;

/**
 * Responsabilità: si occupa della creazione di un commento
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
public class CommentCreate {
    public String body;

    public boolean state;

    public CommentCreate(String body, boolean state) {
        this.body = body;
        this.state = state;
    }

    public String getBody() {
        return body;
    }

    public boolean isState() {
        return state;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public void setState(boolean state) {
        this.state = state;
    }

}