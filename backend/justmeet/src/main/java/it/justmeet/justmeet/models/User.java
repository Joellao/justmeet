package it.justmeet.justmeet.models;

public class User implements UserInterface {
    private final String firstName;
    private final String lastName;
    private final String email;
    private final String birthDate;
    private final String profileImage;
    private final String bio;

    public User(String name, String lastName, String email, String birthDate, String profileImage, String bio) {
        this.firstName = name;
        this.lastName = lastName;
        this.email = email;
        this.birthDate = birthDate;
        this.profileImage = profileImage;
        this.bio = bio;
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

    @Override
    public void modifyProfile() {
        // TODO Auto-generated method stub

    }

    @Override
    public Event createEvent() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean cancelEvent() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public Event modifyEvent() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Comment createComment() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Comment modifyComment() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public boolean cancelComment() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public String addPhoto() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Review createReview() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Review modifyReview() {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void reportComment() {
        // TODO Auto-generated method stub

    }

    @Override
    public void reportBug() {
        // TODO Auto-generated method stub

    }

    public String getProfileImage() {
        return profileImage;
    }

    public String getBio() {
        return bio;
    }

}