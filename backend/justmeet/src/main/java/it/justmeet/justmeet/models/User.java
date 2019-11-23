package it.justmeet.justmeet.models;

public class User {
    private final String firstName;
    private final String lastName;
    private final String email;
    private final String birthDate;

    public User(String name, String lastName, String email, String birthDate) {
        this.firstName = name;
        this.lastName = lastName;
        this.email = email;
        this.birthDate = birthDate;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getEmail() {
        return email;
    }

    public String getBirthDate() {
        return birthDate;
    }

}