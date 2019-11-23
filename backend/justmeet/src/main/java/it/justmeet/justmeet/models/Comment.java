package it.justmeet.justmeet.models;

public class Comment {
    public final String body;
    public final User user;
    public final Event event;
    public final String date;
    public final boolean state;

    public Comment(String body, User user, Event event, String date, boolean state) {
        this.body = body;
        this.user = user;
        this.event = event;
        this.date = date;
        this.state = state;
    }

    public String getBody() {
        return body;
    }

    public User getUser() {
        return user;
    }

    public Event getEvent() {
        return event;
    }

    public String getDate() {
        return date;
    }

    public boolean isState() {
        return state;
    }

}