package it.justmeet.justmeet.models;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

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
    private String date;
    @Column(name = "description")
    private String description;
    @Column(name = "isFree")
    private boolean isFree;
    @Column(name = "cancelled")
    private boolean cancelled = false;
    @Column(name = "categoria")
    private String categoria;
    @Column(name = "maxNumber")
    private int maxNumber;
    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "events_comments", referencedColumnName = "id")
    private List<Comment> comments = new ArrayList<Comment>();
    @OneToMany(mappedBy = "event", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Review> reviews = new ArrayList<Review>();
    @OneToMany(fetch = FetchType.LAZY)
    private List<User> partecipants = new ArrayList<User>();
    // private List<String> photoUrls;
    @Column(name = "publicEvent")
    private boolean publicEvent;

    protected Event() {
    }

    public Event(String name, String location, String description, String date, boolean isFree, String categoria,
            int maxNumber) {
        this.name = name;
        this.location = location;
        this.date = date;
        this.isFree = isFree;
        this.categoria = categoria;
        this.maxNumber = maxNumber;
        // this.comments = new ArrayList<Comment>();
        // this.reviews = new ArrayList<Review>();
        // this.photoUrls = new ArrayList<String>();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @JsonIgnoreProperties({ "partecipatedEvents", "events" })
    public List<User> getPartecipants() {
        return partecipants;
    }

    public void setPartecipants(List<User> partecipants) {
        this.partecipants = partecipants;
    }

    public boolean isPublicEvent() {
        return publicEvent;
    }

    public void setPublicEvent(boolean publicEvent) {
        this.publicEvent = publicEvent;
    }

    public String getName() {
        return name;
    }

    // Per evitare ricorsione, quando si richiama l'utente il campo events non viene
    // incluso
    @JsonIgnoreProperties({ "events", "hibernateLazyInitializer", "partecipatedEvents", "reviews" })
    public AbstractUser getUser() {
        return user;
    }

    public String getLocation() {
        return location;
    }

    public String getDate() {
        return date;
    }

    public boolean isFree() {
        return isFree;
    }

    public String getCategoria() {
        return categoria;
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

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    // public List<Review> getReviews() {
    // return reviews;
    // }

    // public void setReviews(List<Review> reviews) {
    // this.reviews = reviews;
    // }

    // public List<String> getPhotoUrls() {
    // return photoUrls;
    // }

    // public void setPhotoUrls(List<String> photoUrls) {
    // this.photoUrls = photoUrls;
    // }

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

    public void setDate(String date) {
        this.date = date;
    }

    public void setFree(boolean isFree) {
        this.isFree = isFree;
    }

    public void setCancelled(boolean cancelled) {
        this.cancelled = cancelled;
    }

    public void setCategory(String categoria) {
        this.categoria = categoria;
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

    public void addComment(Comment comment) {
        this.comments.add(comment);
    }

    public void addReview(Review review) {
        this.reviews.add(review);
    }

    public void addPartecipant(User user) {
        this.partecipants.add(user);
    }

    @JsonIgnoreProperties({ "partecipatedEvents", "events" })
    public List<User> getParticipants() {
        return partecipants;
    }

    public void setParticipants(List<User> participants) {
        this.partecipants = participants;
    }

}