package it.justmeet.justmeet.controllers;

import com.google.firebase.auth.FirebaseAuthException;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.exceptions.ForbiddenAccess;
import it.justmeet.justmeet.exceptions.ResourceNotFoundException;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.creates.UserCreate;
import it.justmeet.justmeet.models.repositories.AbstractUserRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

/**
 * Responsabilità: coordina le azioni che può eseguire un utente qualsiasi
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */
@RestController
public class UserController {
	@Autowired
	UserRepository userRepo;
	@Autowired
	AbstractUserRepository abstractRepo;

	/**
	 * metodo che mi permette di visualizzare il profilo dell'utente in base al suo
	 * id
	 * 
	 * @param name
	 * @param token
	 * @return l'utente selezionato in base all'username
	 * @throws FirebaseAuthException
	 */
	@GetMapping("/user")
	public AbstractUser getProfile(@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		String userId = WoWoUtility.getInstance().getUid(token);
		AbstractUser user = abstractRepo.findByUid(userId);
		return user;
	}

	/**
	 * metodo che mi permette di visualizzare il profilo dell'utent ein base al suo
	 * username
	 * 
	 * @param name
	 * @param token
	 * @return l'utente selezionato in base all'username
	 * @throws FirebaseAuthException
	 */
	@GetMapping("/user/{userId}")
	public User getOtherProfile(@PathVariable("userId") String otherId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		User other = userRepo.findByUid(otherId);
		if (other == null) {
			throw new ResourceNotFoundException("Questo utente non è stato trovato");
		}
		return other;
	}

	/**
	 * metodo che mi permette di modificare il profilo di un utente
	 * 
	 * @param userId
	 * @param user
	 * @return profilo utente modificato
	 * @throws FirebaseAuthException
	 */
	@PutMapping("/user/{userId}")
	public AbstractUser modifyUser(@PathVariable("userId") String userId, @RequestBody UserCreate user,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		AbstractUser me = abstractRepo.findByUid(userId);
		if (me == null) {
			throw new ResourceNotFoundException();
		}
		if (!me.getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			throw new ForbiddenAccess("Questo account non è tuo");
		}
		me.setBio(user.getBio());
		me.setProfileImage(user.getProfilePhoto());
		me.setUsername(user.getUsername());
		me.setEmail(user.getEmail());
		abstractRepo.save(me);
		return me;
	}

	/**
	 * metodo che mi permette di eliminare un account
	 * 
	 * @param userId
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/user/{userId}") // PORTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	public boolean deleteUser(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		AbstractUser me = abstractRepo.findByUid(userId);
		if (me == null) {
			throw new ResourceNotFoundException();
		}
		if (!me.getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			throw new ForbiddenAccess("Questo account non è tuo");
		}
		try {
			abstractRepo.delete(me);
			return true;
		} catch (Exception e) {
		}
		return false;
	}

	@GetMapping("/user/{userId}/event")
	public List<Event> getEvents(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		AbstractUser user = abstractRepo.findByUid(userId);
		return user.getEvents();
	}

	@GetMapping("/user/{userName}/find")
	public List<User> findProfile(@PathVariable("userName") String userName,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		List<User> result = userRepo.findAll().stream().filter(user -> userName.equals(user.getUsername()))
				.collect(Collectors.toList());
		return result;
	}

	@PatchMapping("/user/{userId}")
	public boolean requestFriend(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		String myId = WoWoUtility.getInstance().getUid(token);
		User user = getOtherProfile(userId, token);
		User me = userRepo.findByUid(myId);

		user.getRequestFriends().add(me);
		if (userRepo.save(user) != null) {
			return true;
		}
		return false;
	}

	@PatchMapping("/user/{userId}/{answer}")
	public boolean answerFriend(@PathVariable("userId") String userId, @PathVariable("answer") Boolean answer,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		String myId = WoWoUtility.getInstance().getUid(token);
		User user = getOtherProfile(userId, token);
		User me = userRepo.findByUid(myId);
		if (answer) {
			me.getFriends().add(user);
			user.getFriends().add(me);
			me.getRequestFriends().remove(user);
		} else {
			me.getRequestFriends().remove(user);
		}
		if (userRepo.save(user) != null && userRepo.save(me) != null) {
			return true;
		}
		return false;
	}

	@GetMapping("/user/friends")
	public List<User> getFriends(@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		String myId = WoWoUtility.getInstance().getUid(token);
		User me = userRepo.findByUid(myId);
		return me.getFriends();
	}

	@GetMapping("/user/requestFriends")
	public List<User> getRequestFriends(@RequestHeader("Authorization") String token) throws FirebaseAuthException {

		String myId = WoWoUtility.getInstance().getUid(token);
		User me = userRepo.findByUid(myId);
		return me.getRequestFriends();
	}

	@PutMapping("/user/{userId}/removeFriend")
	public boolean removeFriend(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		String myId = WoWoUtility.getInstance().getUid(token);
		User me = userRepo.findByUid(myId);
		User user = getOtherProfile(userId, token);

		me.getFriends().remove(user);
		user.getFriends().remove(me);
		if (userRepo.save(me) != null && userRepo.save(user) != null) {
			return true;
		}
		return false;
	}

	@PostMapping("/user/{userId}/uploadProfilePicutre")
	public String uploadProfilePicture(@PathVariable("userId") String userId,
			@RequestHeader("Authorization") String token, @RequestParam("photo") MultipartFile file) throws Exception {
		if (file.isEmpty()) {
			throw new Exception("File vuoto");
		}
		try {
			// Get the file and save it somewhere
			byte[] bytes = file.getBytes();
			String url = WoWoUtility.getPhotoUrl(file.getOriginalFilename(), bytes);
			return url;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}

}