package it.justmeet.justmeet.models;

public class Event {
    private final String name;
    private final User user;
    private final String location;
    private final String date;
    private final boolean isFree;
    private final String categoria;
    private final int maxNumber;

    public Event(String name, User user, String location, String date, boolean isFree, String categoria,
            int maxNumber) {
        this.name = name;
        this.user = user;
        this.location = location;
        this.date = date;
        this.isFree = isFree;
        this.categoria = categoria;
        this.maxNumber = maxNumber;
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
}