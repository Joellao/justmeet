package it.justmeet.justmeet.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

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
    @Column(name = "profileImage")
    protected String profileImage;
    @Column(name = "bio")
    protected String bio;
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @OrderBy("date DESC")
    protected List<Event> events = new ArrayList<>();
    @Column(name = "userType", insertable = false, updatable = false)
    protected int type;

    protected boolean canCreatePublicEvent = true;
    protected boolean canSeeOthersProfile = true;

    public boolean isCanCreatePublicEvent() {
        return canCreatePublicEvent;
    }

    public void setCanCreatePublicEvent(boolean canCreatePublicEvent) {
        this.canCreatePublicEvent = canCreatePublicEvent;
    }

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

}