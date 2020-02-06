package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

/**
 * Responsabilità: definisce un evento
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity
@Table(name = "events")
public class Event {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE)
	@Column(name = "id")
	private Long id;
	@Column(name = "name")
	private String name;
	@ManyToOne(fetch = FetchType.EAGER, optional = false)
	@JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private AbstractUser user;
	@Column(name = "location")
	private String location;
	@Column(name = "date")
	@Temporal(TemporalType.TIMESTAMP)
	private Date date;
	@Column(name = "description")
	private String description;
	@Column(name = "isFree")
	private boolean isFree;
	@Column(name = "cancelled")
	private boolean cancelled = false;
	@Column(name = "category")
	private Category category;
	@Column(name = "maxNumber")
	private int maxNumber;
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@OnDelete(action = OnDeleteAction.CASCADE)
	@JoinColumn(name = "events_comments", referencedColumnName = "id")
	private List<Comment> comments = new ArrayList<Comment>();
	@OneToMany(mappedBy = "event", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	private List<Review> reviews = new ArrayList<Review>();
	@ManyToMany(fetch = FetchType.LAZY)
	private List<User> partecipants = new ArrayList<User>();
	@OneToMany(fetch = FetchType.LAZY)
	@OnDelete(action = OnDeleteAction.CASCADE)
	@JoinColumn(name = "events_photos", referencedColumnName = "event_id")
	private List<Photo> photos = new ArrayList<Photo>();
	@Column(name = "isPublic")
	private boolean isPublic;
	@Column(name = "longitude")
	private double longitude;
	@Column(name = "latitude")
	private double latitude;

	protected Event() {
	}

	public Event(String name, String location, String description, Date date, boolean isFree, Category category,
			int maxNumber) {
		this.name = name;
		this.location = location;
		this.description = description;
		this.date = date;
		this.isFree = isFree;
		this.category = category;
		this.maxNumber = maxNumber;
	}

	public void addComment(Comment comment) {
		this.comments.add(comment);
	}

	public void addReview(Review review) {
		this.reviews.add(review);
	}

	public void addPartecipant(User user) {
		this.partecipants.add(user);
	}

	public void removePartecipant(User user) {
		this.partecipants.remove(user);
	}

	public void addPhoto(Photo photo) {
		this.photos.add(photo);
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@JsonIgnoreProperties({ "partecipatedEvents", "events", "announcements", "requestFriends", "friends" })
	public List<User> getPartecipants() {
		return partecipants;
	}

	public void setPartecipants(List<User> partecipants) {
		this.partecipants = partecipants;
	}

	public boolean isPublicEvent() {
		return isPublic;
	}

	public void setPublicEvent(boolean isPublic) {
		this.isPublic = isPublic;
	}

	public String getName() {
		return name;
	}

	// Per evitare ricorsione, quando si richiama l'utente il campo events non viene
	// incluso
	@JsonIgnoreProperties({ "events", "hibernateLazyInitializer", "partecipatedEvents", "reviews", "requestFriends",
			"friends" })
	public AbstractUser getUser() {
		return user;
	}

	public String getLocation() {
		return location;
	}

	public Date getDate() {
		return date;
	}

	public boolean isFree() {
		return isFree;
	}

	public Category getCategory() {
		return category;
	}

	public int getMaxNumber() {
		return maxNumber;
	}

	@JsonIgnoreProperties({ "event" })
	public List<Review> getReviews() {
		return reviews;
	}

	public void setReviews(List<Review> reviews) {
		this.reviews = reviews;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	@JsonIgnoreProperties("user")
	public List<Photo> getPhotoUrls() {
		return photos;
	}

	public void setPhotoUrls(List<Photo> photos) {
		this.photos = photos;
	}

	public boolean isCancelled() {
		return cancelled;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUser(AbstractUser user) {
		this.user = user;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public void setFree(boolean isFree) {
		this.isFree = isFree;
	}

	public void setCancelled(boolean cancelled) {
		this.cancelled = cancelled;
	}

	public void setMaxNumber(int maxNumber) {
		this.maxNumber = maxNumber;
	}

	public List<Comment> getComments() {
		return comments;
	}

	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}

	@JsonIgnoreProperties({ "partecipatedEvents", "events" })
	public List<User> getParticipants() {
		return partecipants;
	}

	public void setParticipants(List<User> participants) {
		this.partecipants = participants;
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