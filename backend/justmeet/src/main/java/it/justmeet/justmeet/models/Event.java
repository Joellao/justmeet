package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.List;

public class Event {
    private final String name;
    private final User user;
    private final String location;
    private final String date;
    private final boolean isFree;
    private final boolean cancelled = false;
    private final String categoria;
    private final int maxNumber;
    private List<Comment> comments;
    private List<Review> reviews;
    private List<String> photoUrls;

    public Event(String name, User user, String location, String date, boolean isFree, String categoria,
            int maxNumber) {
        this.name = name;
        this.user = user;
        this.location = location;
        this.date = date;
        this.isFree = isFree;
        this.categoria = categoria;
        this.maxNumber = maxNumber;
        this.comments = new ArrayList<Comment>();
        this.reviews = new ArrayList<Review>();
        this.photoUrls = new ArrayList<String>();
    }

    public String getName() {
        return name;
    }

    public User getUser() {
        return user;
    }

    public String getLocation() {
        return location;
    }

    public String getDate() {
        return date;
    }

    public boolean isFree() {
        return isFree;
    }

    public String getCategoria() {
        return categoria;
    }

    public int getMaxNumber() {
        return maxNumber;
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

    public List<String> getPhotoUrls() {
        return photoUrls;
    }

    public void setPhotoUrls(List<String> photoUrls) {
        this.photoUrls = photoUrls;
    }

    public boolean isCancelled() {
        return cancelled;
    }
}