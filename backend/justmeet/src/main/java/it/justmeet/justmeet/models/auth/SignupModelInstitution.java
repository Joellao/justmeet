package it.justmeet.justmeet.models.auth;

/**
 * Responsabilità: definisce il modello per la registrazione dell'utente istituzionale 
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

public class SignupModelInstitution {
	private String userName;
    private String name;
    private String email;
    private String password;

    public SignupModelInstitution(String username, String name, String email, String password) {
    	this.userName=username;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    
    public String getUserName() {
		return userName;
	}


	public void setUserName(String userName) {
		this.userName = userName;
	}


	public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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