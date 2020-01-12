package it.justmeet.justmeet.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorType;
import javax.persistence.FetchType;
import java.util.List;
import java.util.ArrayList;

/**
 * Responsabilità: definisce un qualsiasi utente auteticato
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity(name = "AbstractUser")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@Table(name = "users")
@DiscriminatorColumn(discriminatorType = DiscriminatorType.INTEGER, name = "userType", columnDefinition = "SMALLINT")
public abstract class AbstractUser {
	@Id
	@Column(name = "uid")
	protected String uid;
	@Column(name = "userName")
	protected String userName;
	@Column(name = "firstName")
	protected String firstName;
	@Column(name = "email")
	protected String email;
	@Column(name = "profileImage", length = 4000)
	protected String profileImage;
	@Column(name = "bio")
	protected String bio;
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
	@OnDelete(action = OnDeleteAction.CASCADE)
	@OrderBy("date DESC")
	protected List<Event> events = new ArrayList<>();
	@Column(name = "userType", insertable = false, updatable = false)
	protected int type;
	@OneToMany(fetch = FetchType.LAZY)
	protected List<AbstractUser> requestFriends = new ArrayList<AbstractUser>();
	@ManyToMany(fetch = FetchType.LAZY)
	protected List<AbstractUser> friends = new ArrayList<AbstractUser>();
	@Column(name = "longitude")
	protected double longitude;
	@Column(name = "latitude")
	private double latitude;

	protected boolean canCreatePublicEvent = true;
	protected boolean canSeeOthersProfile = true;
	protected boolean canBeFriend = true;
	protected boolean canCreateAnnouncement = true;

	public AbstractUser() {
	}

	public AbstractUser(String uid, String userName, String firstName, String email) {
		this.uid = uid;
		this.userName = userName;
		this.firstName = firstName;
		this.email = email;
	}

	public void addEvent(Event e) {
		this.events.add(e);
	}

	public boolean isCanCreateAnnouncement() {
		return canCreateAnnouncement;
	}

	public void setCanCreateAnnouncement(boolean canCreateAnnouncement) {
		this.canCreateAnnouncement = canCreateAnnouncement;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public boolean isCanBeFriend() {
		return canBeFriend;
	}

	public void setCanBeFriend(boolean canBeFriend) {
		this.canBeFriend = canBeFriend;
	}

	public boolean isCanCreatePublicEvent() {
		return canCreatePublicEvent;
	}

	public void setCanCreatePublicEvent(boolean canCreatePublicEvent) {
		this.canCreatePublicEvent = canCreatePublicEvent;
	}

	public String getUsername() {
		return userName;
	}

	public void setUsername(String userName) {
		this.userName = userName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public String getBio() {
		return bio;
	}

	public void setBio(String bio) {
		this.bio = bio;
	}

	public List<Event> getEvents() {
		return events;
	}

	public void setEvents(List<Event> events) {
		this.events = events;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public boolean isCanSeeOthersProfile() {
		return canSeeOthersProfile;
	}

	public void setCanSeeOthersProfile(boolean canSeeOthersProfile) {
		this.canSeeOthersProfile = canSeeOthersProfile;
	}

	@JsonIgnoreProperties({ "friends", "requestFriends", "partecipatedEvents", "events" })
	public List<AbstractUser> getFriends() {
		return friends;
	}

	public void setFriends(List<AbstractUser> friends) {
		this.friends = friends;
	}

	public List<AbstractUser> getRequestFriends() {
		return requestFriends;
	}

	public void setRequestFriends(List<AbstractUser> requestFriends) {
		this.requestFriends = requestFriends;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

}