package it.justmeet.justmeet.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuthException;

import it.justmeet.justmeet.config.WoWoUtility;
import it.justmeet.justmeet.models.AbstractUser;
import it.justmeet.justmeet.models.Announcement;
import it.justmeet.justmeet.models.Event;
import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.repositories.EventRepository;
import it.justmeet.justmeet.models.repositories.UserRepository;

@RestController
public class FeedController {

	@Autowired
	UserRepository userRepo; // jpa è una libreria
	
	private List<Event> getEvents(@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		String userId = WoWoUtility.getInstance().getUid(token);
		AbstractUser user = userRepo.findByUid(userId);
		List<AbstractUser> friends=user.getFriends();
		List<Event> events=new ArrayList<Event>();
		friends.forEach(friend -> 
			events.addAll(friend.getEvents())
		);
		return events;
	}
	
	private List<Announcement> getAnnouncement(@RequestHeader("Authorization") String token) throws FirebaseAuthException {
		String userId = WoWoUtility.getInstance().getUid(token);
		AbstractUser user = userRepo.findByUid(userId);
		List<User> friends=(List<User>)(List<?>) user.getFriends();
		List<Announcement> announcement=new ArrayList<Announcement>();
		friends.forEach(friend -> 
			announcement.addAll(friend.getAnnouncements())
		);
		return announcement;
	}
	
	@GetMapping("/feed")
	public List<Object> getFeed(@RequestHeader("Authorization") String token) throws FirebaseAuthException{
		List<Object> lista=new ArrayList<Object>();
		lista.addAll(getAnnouncement(token));
		lista.addAll(getEvents(token));
		return lista;
	}
}
