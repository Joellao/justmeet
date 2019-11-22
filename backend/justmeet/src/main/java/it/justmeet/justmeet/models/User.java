package it.justmeet.justmeet.models;

public class User {
    private final String firstName;
    private final String lastName;

    public User(String name, String lastName) {
        this.firstName = name;
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

}