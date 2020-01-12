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
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.Photo;
import it.justmeet.justmeet.models.creates.UserCreate;
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
		AbstractUser user = userRepo.findByUid(userId);
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
	public AbstractUser getOtherProfile(@PathVariable("userId") String otherId,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		String userId = WoWoUtility.getInstance().getUid(token);
		AbstractUser me = userRepo.findByUid(userId);
		if (me.isCanSeeOthersProfile()) {
			AbstractUser other = userRepo.findByUid(otherId);
			return other;
		}
		return null;
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
		// Modifica al database con le nuove cose
		AbstractUser me = userRepo.findByUid(userId);
		if (!me.getUid().equals(WoWoUtility.getInstance().getUid(token))) {
			return null;
		}
		me.setBio(user.getBio());
		me.setProfileImage(user.getProfilePhoto());
		me.setUsername(user.getUsername());
		me.setEmail(user.getEmail());
		userRepo.save(me);
		return me;
	}

	/**
	 * metodo che mi permette di eliminare un account
	 * 
	 * @param userId
	 * @throws FirebaseAuthException
	 */
	@DeleteMapping("/user/{userId}") // PORTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	public void deleteUser(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		AbstractUser me = userRepo.findByUid(userId);
		if (!me.getUid().equals(WoWoUtility.getInstance().getUid(token))) {
		}
		userRepo.delete(me);
	}

	@GetMapping("/user/{userId}/event")
	public List<Event> getEvents(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		AbstractUser user = userRepo.findByUid(userId);
		return user.getEvents();
	}

	@GetMapping("/user/{userName}/find")
	public List<AbstractUser> findProfile(@PathVariable("userName") String userName,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		if (!getProfile(token).isCanSeeOthersProfile())
			return null;
		List<AbstractUser> result = userRepo.findAll().stream().filter(user -> userName.equals(user.getUsername()))
				.collect(Collectors.toList());
		return result;

	}

	@PatchMapping("/user/{userId}")
	public void requestFriend(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		AbstractUser user = getOtherProfile(userId, token);
		AbstractUser me = getProfile(token);
		if (!user.isCanBeFriend() || !me.isCanBeFriend())
			return;
		user.getRequestFriends().add(me);
		userRepo.save(user);
	}

	@PatchMapping("/user/{userId}/{answer}")
	public void answerFriend(@PathVariable("userId") String userId, @PathVariable("answer") Boolean answer,
			@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		AbstractUser user = getOtherProfile(userId, token);
		AbstractUser me = getProfile(token);
		if (answer) {
			me.getFriends().add(user);
			user.getFriends().add(me);
			me.getRequestFriends().remove(user);
		} else {
			me.getRequestFriends().remove(user);
		}
		userRepo.save(user);
		userRepo.save(me);

	}

	@GetMapping("/user/friends")
	public List<AbstractUser> getFriends(@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		if (!getProfile(token).isCanBeFriend())
			return null;
		return getProfile(token).getFriends();
	}

	@GetMapping("/user/requestFriends")
	public List<AbstractUser> getRequestFriends(@RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		if (!getProfile(token).isCanBeFriend())
			return null;
		return getProfile(token).getRequestFriends();
	}

	@PutMapping("/user/{userId}/removeFriend")
	public void removeFriend(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token)
			throws FirebaseAuthException {
		WoWoUtility.getInstance().getUid(token);
		AbstractUser user = getOtherProfile(userId, token);
		AbstractUser me = getProfile(token);
		me.getFriends().remove(user);
		user.getFriends().remove(me);
		userRepo.save(me);
		userRepo.save(user);
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