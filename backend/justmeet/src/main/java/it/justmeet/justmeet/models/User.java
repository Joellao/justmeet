package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

@Entity(name = "User")
@Table(name = "users")
<<<<<<< HEAD
@DiscriminatorValue("1")
public class User extends AbstractUser {

	@Column(name = "lastName")
	private String lastName;
	@Column(name = "birthDate")
	private String birthDate;
	@OneToMany(fetch = FetchType.LAZY)
=======
public class User implements UserInterface {
	@Id
	@Column(name = "uid")
	private String uid;
	@Column(name = "firstName")
	private String firstName;
	@Column(name = "lastName")
	private String lastName;
	@Column(name = "email")
	private String email;
	@Column(name = "birthDate")
	private String birthDate;
	@Column(name = "profileImage")
	private String profileImage;
	@Column(name = "bio")
	private String bio;
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
	private List<Event> events = new ArrayList<>();
	@ManyToOne(fetch = FetchType.LAZY)
>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
	private List<Event> partecipatedEvents = new ArrayList<Event>();

	protected User() {
	}

	public User(String uid, String name, String lastName, String email, String birthDate) {
<<<<<<< HEAD
		super(uid, name, email);
		this.lastName = lastName;
		this.birthDate = birthDate;
	}

=======
		this.uid = uid;
		this.firstName = name;
		this.lastName = lastName;
		this.email = email;
		this.birthDate = birthDate;
	}


>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
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

<<<<<<< HEAD
=======
	@Override
	public void modifyProfile() {
		// TODO Auto-generated method stub
		
	}

	public Event createEvent() {
		// TODO Auto-generated method stub
		Event evento = new Event(event.getName(), event.getLocation(),event.getDescription(), event.getDate(), event.isFree(),
	                event.getCategory(), event.getMaxPersons());
	        evento.setUser(this);
	        eventRepo.save(evento);
	        user.addEvent(evento);
	        userRepo.save(this);
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
	public void reportComment() {
		// TODO Auto-generated method stub

	}

	@Override
	public void reportBug() {
		// TODO Auto-generated method stub

	}

>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
	public String getProfileImage() {
		return profileImage;
	}

	public String getBio() {
		return bio;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public void setBio(String bio) {
		this.bio = bio;
	}

	@JsonIgnoreProperties({ "user" })
	public List<Event> getEvents() {
		return events;
	}

	public void setEvents(List<Event> events) {
		this.events = events;
	}

<<<<<<< HEAD
=======
	public void addEvent(Event e) {
		this.events.add(e);
	}

>>>>>>> 076cf74f6bcb1f83bbb6d3bacc1b846e6ebec218
	public void partecipateEvent(Event e) {
		this.partecipatedEvents.add(e);
	}

	public List<Event> getPartecipatedEvents() {
		return partecipatedEvents;
	}

	public void setPartecipatedEvents(List<Event> partecipatedEvents) {
		this.partecipatedEvents = partecipatedEvents;
	}

}