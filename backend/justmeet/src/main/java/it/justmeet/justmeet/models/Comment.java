package it.justmeet.justmeet.models;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

/**
 * Responsabilità: definisce un commento
 * 
 * @author Joel Sina
 * @author Giulia Morelli
 * @author Jessica Piccioni
 *
 */

@Entity
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id")
    private Long id;
    @Column(name = "body")
    private String body;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private AbstractUser user;
    /*
     * @ManyToOne(fetch = FetchType.LAZY, optional = false)
     * 
     * @JoinColumn(name = "event_id", referencedColumnName = "id", nullable = false)
     * 
     * @OnDelete(action = OnDeleteAction.CASCADE)
     * 
     * @JsonIgnore public Event event;
     */
    @Column(name = "date")
    @Temporal(TemporalType.TIMESTAMP)
    public Date date;

    protected Comment() {
    }

    public Comment(String body, AbstractUser user, Date date) {
        this.body = body;
        this.user = user;
        this.date = date;
    }

    public String getBody() {
        return body;
    }

    @JsonIgnoreProperties({ "events", "partecipatedEvents", "reviews", "requestFriends", "announcements", "friends" })
    public AbstractUser getUser() {
        return user;
    }

    public Date getDate() {
        return date;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public void setUser(AbstractUser user) {
        this.user = user;
    }

    public void setDate(Date date) {
        this.date = date;
    }

}