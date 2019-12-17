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
    public String date;
    public boolean state;

    public CommentCreate(String body, String date, boolean state) {
        this.body = body;
        this.date = date;
        this.state = state;
    }

    public String getBody() {
        return body;
    }

    public String getDate() {
        return date;
    }

    public boolean isState() {
        return state;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setState(boolean state) {
        this.state = state;
    }

}