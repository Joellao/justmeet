package it.justmeet.justmeet.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Responsabilità: definisce una recensione  
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity
@Table(name = "reviews")
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id")
    private Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    public User user;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "event_id", referencedColumnName = "id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    public Event event;
    @Column(name = "body")
    public String body;
    @Column(name = "stars")
    public int stars;
    @Column(name = "date")
    public String date;

    protected Review() {
    	
    }
    
    public Review(User user, Event event, String body, int stars, String date) {
        this.user = user;
        this.event = event;
        this.body = body;
        this.stars = stars;
        this.date = date;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public void setStars(int stars) {
        this.stars = stars;
    }

    public void setDate(String date) {
        this.date = date;
    }

    @JsonIgnoreProperties({ "reviews", "events" })
    public User getUser() {
        return user;
    }

    public Event getEvent() {
        return event;
    }

    public String getBody() {
        return body;
    }

    public int getStars() {
        return stars;
    }

    public String getDate() {
        return date;
    }
    
    public void setUser(User user) {
        this.user = user;
    }

}
