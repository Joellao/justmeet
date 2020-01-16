package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

/**
 * Responsabilità: definisce un utente auteticato base
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity(name = "User")
@Table(name = "users")
@DiscriminatorValue("1")
public class User extends AbstractUser {

	@Column(name = "lastName")
	private String lastName;
	@Column(name = "birthDate")
	private Date birthDate;
	@OneToMany(fetch = FetchType.LAZY)
	@OrderBy("date DESC")
	private List<Event> partecipatedEvents = new ArrayList<Event>();
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
	@OnDelete(action = OnDeleteAction.CASCADE)
	@OrderBy("date DESC")
	private List<Announcement> announcements = new ArrayList<Announcement>();

	@JsonIgnoreProperties({ "user" })
	public List<Announcement> getAnnouncements() {
		return announcements;
	}

	public void setAnnouncements(List<Announcement> announcements) {
		this.announcements = announcements;
	}

	protected User() {
	}

	public User(String uid, String username, String firstName, String lastName, String email, Date birthDate) {
		super(uid, username, firstName, email);
		this.lastName = lastName;
		this.birthDate = birthDate;
		canCreatePublicEvent = false;
	}

	public void addPartecipateEvent(Event e) {
		this.partecipatedEvents.add(e);
	}

	public void removePartecipateEvent(Event e) {
		this.partecipatedEvents.remove(e);
	}

	public String getUsername() {
		return userName;
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

	public Date getBirthDate() {
		return birthDate;
	}

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

	public void setUsername(String userName) {
		this.userName = userName;
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

	public void setBirthDate(Date birthDate) {
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

	@JsonIgnoreProperties({ "partecipants" })
	public List<Event> getPartecipatedEvents() {
		return partecipatedEvents;
	}

	public void setPartecipatedEvents(List<Event> partecipatedEvents) {
		this.partecipatedEvents = partecipatedEvents;
	}

}