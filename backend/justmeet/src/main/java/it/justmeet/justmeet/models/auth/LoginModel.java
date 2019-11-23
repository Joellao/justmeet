package it.justmeet.justmeet.models.auth;

public class LoginModel {
    private final String email;
    private final String password;
    private final boolean returnSecureToken = true;

    public LoginModel(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public boolean getReturnSecureToken() {
        return returnSecureToken;
    }

}