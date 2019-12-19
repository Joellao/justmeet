package it.justmeet.justmeet.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
    public String body;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    public AbstractUser user;
    /*@ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "event_id", referencedColumnName = "id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    public Event event;*/
    @Column(name = "date")
    public String date;
    @Column(name = "state")
    public boolean state;

    protected Comment() {
    }

    public Comment(String body, AbstractUser user, /* Event event*/ String date, boolean state) {
        this.body = body;
        this.user = user;
        //this.event = event;
        this.date = date;
        this.state = state;
    }

    public String getBody() {
        return body;
    }

    @JsonIgnoreProperties({ "events" })
    public AbstractUser getUser() {
        return user;
    }

   /* public Event getEvent() {
        return event;
    }*/

    public String getDate() {
        return date;
    }

    public boolean isState() {
        return state;
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

    /*public void setEvent(Event event) {
        this.event = event;
    }*/

    public void setDate(String date) {
        this.date = date;
    }

    public void setState(boolean state) {
        this.state = state;
    }

}