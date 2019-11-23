package it.justmeet.justmeet.models;

public class Review {
    public final User user;
    public final Event event;
    public final String body;
    public final int stars;
    public final String date;

    public Review(User user, Event event, String body, int stars, String date) {
        this.user = user;
        this.event = event;
        this.body = body;
        this.stars = stars;
        this.date = date;
    }

    public User getUser() {
        return user;
    }

    public Event getEvent() {
        return event;
    }

    public String getBody() {
        return body;
    }

    public int getStars() {
        return stars;
    }

    public String getDate() {
        return date;
    }

}
