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
@Table(name = "segnalazione_commento")
public class SegnalazioneCommento {
    @Id
    @GeneratedValue(strategy = GenerationType.TABLE)
    @Column(name = "id")
    private Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", referencedColumnName = "uid", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    public AbstractUser user;
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "comment_id", referencedColumnName = "id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Comment comment;
    @Column(name = "body")
    private String body;

    protected SegnalazioneCommento() {
    }

    public SegnalazioneCommento(AbstractUser user, Comment comment, String body) {
        this.user = user;
        this.comment = comment;
        this.body = body;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }

    public void setBody(String body) {
        this.body = body;
    }

    @JsonIgnoreProperties({ "reviews", "events", "partecipatedEvents", "announcements", "friends", "requestFriends" })
    public AbstractUser getUser() {
        return user;
    }

    public String getBody() {
        return body;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Comment getComment() {
        return comment;
    }

}
