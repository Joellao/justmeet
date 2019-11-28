package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.List;

public class Announcement {
    private final String name;
    private final User user;
    private final String categoria;
    private List<Comment> comments;
    private List<Review> reviews;

    public Announcement(String name, User user, String categoria) {
        this.name = name;
        this.user = user;
        this.categoria = categoria;
        this.comments = new ArrayList<Comment>();
        this.reviews = new ArrayList<Review>();
    }

    public String getName() {
        return name;
    }

    public User getUser() {
        return user;
    }

    public String getCategoria() {
        return categoria;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public List<Review> getReviews() {
        return reviews;
    }

    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }
}