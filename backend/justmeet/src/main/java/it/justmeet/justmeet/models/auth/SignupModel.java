package it.justmeet.justmeet.models.auth;

public class SignupModel {
    private final String email;
    private final String password;

    public SignupModel(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

}