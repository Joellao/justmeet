package it.justmeet.justmeet.models.creates;

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

    public CommentCreate(String body) {
        this.body = body;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

}