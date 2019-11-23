package it.justmeet.justmeet.models;

public interface UserInterface {

    public void modifyProfile();

    public Event createEvent();

    public boolean cancelEvent();

    public Event modifyEvent();

    public Comment createComment();

    public Comment modifyComment();

    public boolean cancelComment();

    public String addPhoto();

    public Review createReview();

    public Review modifyReview();

    public void reportComment();

    public void reportBug();

}