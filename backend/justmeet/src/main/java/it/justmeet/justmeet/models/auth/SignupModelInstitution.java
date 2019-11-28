package it.justmeet.justmeet.models.auth;

public class SignupModelInstitution {
    private String name;
    private int p_iva;
    private String email;
    private String password;

    public SignupModelInstitution(String name, int p_iva, String email, String password) {
        this.name = name;
        this.p_iva = p_iva;
        this.email = email;
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getP_iva() {
        return p_iva;
    }

    public void setP_iva(int p_iva) {
        this.p_iva = p_iva;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

}