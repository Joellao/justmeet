package it.justmeet.justmeet.controllers;

import java.io.IOException;
import java.net.URISyntaxException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.auth.UserRecord.CreateRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import it.justmeet.justmeet.exceptions.EmailAlreadyExistsException;
import it.justmeet.justmeet.exceptions.WrongPasswordException;
import it.justmeet.justmeet.models.Institution;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.repositories.UserRepository;
import it.justmeet.justmeet.models.auth.LoginModel;
import it.justmeet.justmeet.models.auth.SignupModelInstitution;
import it.justmeet.justmeet.models.auth.SignupModelUser;

/**
 * Responsabilità: coordina le azioni di registrazione e login
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica PIccioni
 *
 */
@RestController
public class AuthController {
	@Autowired
	UserRepository userRepo;

	/**
	 * metodo che mi permette di fare il login all'interno del sistema
	 * 
	 * @param email
	 * @param password
	 * @return
	 * @throws IOException
	 * @throws SQLException
	 * @throws URISyntaxException
	 * @throws WrongPasswordException
	 */
	@PostMapping("/login")
	public Object login(@RequestParam("email") String email, @RequestParam("password") String password)
			throws IOException, SQLException, URISyntaxException, WrongPasswordException {
		if (!validateEmail(email))
			throw new IllegalArgumentException("Email non valida");
		if (password.length() < 8)
			throw new WrongPasswordException("Password troppo corta");
		Object json = fireBaseSignIn(email, password);
		return json;
	}

	/**
	 * metodo che permette la registrazione dell'utente istituzionale
	 * 
	 * @param institution
	 * @return l'istituzione
	 * @throws EmailAlreadyExistsException
	 * @throws SQLException
	 * @throws URISyntaxException
	 * @throws WrongPasswordException
	 */
	@PostMapping("/signupInstitution")
	public UserRecord signupInstitution(@RequestBody SignupModelInstitution institution)
			throws EmailAlreadyExistsException, SQLException, URISyntaxException, WrongPasswordException {
		CreateRequest request = new CreateRequest().setEmail(institution.getEmail()).setEmailVerified(false)
				.setPassword(institution.getPassword()).setDisplayName(institution.getName()).setDisabled(false);
		UserRecord userRecord = null;
		try {
			userRecord = FirebaseAuth.getInstance().createUser(request);
		} catch (FirebaseAuthException e) {
			if (e.getErrorCode() == "email-already-exists") {
				throw new EmailAlreadyExistsException();
			}
		}
		if (!validateEmail(institution.getEmail()))
			throw new IllegalArgumentException("Email non valida");
		if (institution.getPassword().length() < 8)
			throw new WrongPasswordException("Password troppo corta");
		userRepo.save(new Institution(userRecord.getUid(), institution.getUserName(), userRecord.getDisplayName(),
				userRecord.getEmail()));
		return userRecord;
	}

	/**
	 * metodo che permette la registrazione dell'utente base
	 * 
	 * @param user
	 * @return l'utente base
	 * @throws EmailAlreadyExistsException
	 * @throws SQLException
	 * @throws URISyntaxException
	 * @throws WrongPasswordException
	 * @throws ParseException
	 */
	@PostMapping("/signupUser")
	public UserRecord signupUser(@RequestBody SignupModelUser user) throws EmailAlreadyExistsException, SQLException,
			URISyntaxException, WrongPasswordException, ParseException {
		CreateRequest request = new CreateRequest().setEmail(user.getEmail()).setEmailVerified(false)
				.setPassword(user.getPassword()).setDisplayName(user.getFirstName() + " " + user.getLastName())
				.setDisabled(false);

		UserRecord userRecord = null;
		try {
			userRecord = FirebaseAuth.getInstance().createUser(request);
		} catch (FirebaseAuthException e) {
			if (e.getErrorCode() == "email-already-exists") {
				throw new EmailAlreadyExistsException();
			}
		}
		if (!validateEmail(user.getEmail()))
			throw new IllegalArgumentException("Email non valida");
		if (user.getPassword().length() < 8)
			throw new WrongPasswordException("Password troppo corta");
		Date date = new SimpleDateFormat("dd/MM/yyyy").parse(user.getBirthDate());
		userRepo.save(new User(userRecord.getUid(), user.getUserName(), user.getFirstName(), user.getLastName(),
				user.getEmail(), date));

		return userRecord;
	}

	@ResponseStatus(value = HttpStatus.BAD_REQUEST, reason = "Email already exists")
	@ExceptionHandler(EmailAlreadyExistsException.class)
	public void handle() {
	}

	public Object fireBaseSignIn(String email, String password) {
		LoginModel login = new LoginModel(email, password);
		RestTemplate t = new RestTemplate();
		Object result = t.postForObject(
				"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDF0V8-WK52yY_HKsoar4D0NBkY2zvn-pQ",
				login, Object.class);
		return result;
	}

	private boolean validateEmail(String email) {
		String expressionPlus = "^[\\w\\-]([\\.\\w])+[\\w]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";
		Pattern pPlus = Pattern.compile(expressionPlus, Pattern.CASE_INSENSITIVE);
		Matcher mPlus = pPlus.matcher(email);
		return mPlus.matches();
	}

}